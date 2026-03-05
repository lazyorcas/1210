# Codebase Review

## Scope
This review covers the Rails monolith under `/workspace/1210` with focus on architecture, security, correctness, and system design.

## High-level architecture
- Rails 7 monolith with server-rendered views (Hotwire/Turbo), Sidekiq jobs, and PostgreSQL.
- Domain appears to be social planning: users, friendships (invitations), meetups, ideas (polling), availability, and memories.
- Uses STI + polymorphic associations extensively (`Thing`, `Invitation`, `Comment`, `Pollable::Option`).

## What is working well
1. **Clear domain language**: models and controllers map cleanly to domain actions (`Meetup`, `Idea`, `Availability`, invitation flows).
2. **Strong ownership checks in several hotspots**: many update flows scope records to `current_user` associations.
3. **Background processing for push/email**: avoids blocking web requests for notifications.
4. **Mobile-first intent is explicit** via `require_mobile!` and tailored layouts.

## Critical / high-priority findings

### 1) Time-based default scopes are evaluated at class load (stale query boundary)
- `PushSubscription` and `PublicHash` default scopes embed `Time.zone.now` directly.
- In long-lived Rails processes, these scopes can drift and return incorrect records because the literal timestamp was captured when class was loaded.
- **Impact**: expired records may remain visible or valid longer than expected; notification logic can behave incorrectly.
- **Files**:
  - `app/models/push_subscription.rb`
  - `app/models/public_hash.rb`

### 2) Potential runtime exception on user profile update
- `User#remove_whitespaces` calls `city.strip!` unguarded.
- If `city` is `nil` (allowed by controller flow and validation setup), this raises `NoMethodError` during validation.
- **Impact**: profile updates and user creation can fail unexpectedly.
- **File**: `app/models/user.rb`

### 3) Authorization gap in friend invitation acceptance
- `User::InvitationsController#update` does `User::Invitation.find(params[:id])` and then sets `invitee = current_user`, `is_accepted = true`.
- There is no scope ensuring the invitation is intended for this user (or unclaimed public hash flow constraints).
- **Impact**: a logged-in user could potentially accept arbitrary invitation IDs.
- **File**: `app/controllers/user/invitations_controller.rb`

### 4) Suspicious time comparison in `SocialNetworkController`
- Compares `Time.zone.now >= "07:00"`.
- Comparing a `Time` object with a string is invalid and likely raises at runtime.
- **Impact**: request-time exception for authenticated users hitting pages that run `load_default_modal_src`.
- **File**: `app/controllers/social_network_controller.rb`

## Medium-priority findings

### 5) Extensive use of `default_scope` across core models
- Found in `Thing`, `Meetup`, `Idea`, `Availability`, `PushSubscription`, `PublicHash`, STI invitation subclasses.
- This can cause hidden query behavior, difficult debugging, and accidental data loss in admin/reporting/background tasks.
- **Recommendation**: replace with explicit named scopes for lifecycle states (`active`, `not_deleted`, `unexpired`).

### 6) Missing or sparse automated test coverage
- `test/` mostly contains `.keep` placeholders and scaffold helper.
- Complex business rules (invitation lifecycle, notifications, scoping) are under-tested.
- **Recommendation**: prioritize model and request specs for security-sensitive and stateful flows.

### 7) Documentation gap
- `README.md` is still the default template.
- Missing setup and operational docs (env vars, Sidekiq, Redis, cron/scheduler tasks, deploy/runbook).
- **Impact**: onboarding and incident response risk.

## System design observations

### Data model complexity
- The app uses polymorphic invitation patterns to unify flows across entities. This is powerful but increases cognitive load.
- Suggestion: codify a lightweight service layer around invitation transitions and notification fanout to reduce callback coupling.

### Notification architecture
- Push + email fallback exists, but dispatch logic is scattered across callbacks in multiple models.
- Suggestion: centralize fanout via domain events (e.g., `MeetupCreated`, `IdeaStatusChanged`) and dedicated handlers/jobs.

### Query patterns and scalability
- Some user-facing lists compute arrays in Ruby (`@ideas & current_user.invited_ideas`, map/filter loops over records).
- This is acceptable early on but may degrade for larger user graphs.
- Suggestion: move high-traffic list filtering/grouping to SQL and index around `invitations` and `availabilities` access patterns.

## Recommended remediation plan
1. **Security/correctness first (this week)**
   - Fix invitation update scoping.
   - Fix `Time` vs string comparison.
   - Make `city.strip!` nil-safe.
   - Replace time-literal default scopes with lambdas.
2. **Stability next (1–2 sprints)**
   - Add request tests for authz boundaries.
   - Add model tests for invitation transitions and callbacks.
3. **Maintainability (ongoing)**
   - Reduce `default_scope` usage.
   - Introduce service objects/event handlers for notifications.
   - Expand README into operational docs.

## Suggested first test targets
- `User::InvitationsController#update` authorization cases.
- `SocialNetworkController#load_default_modal_src` morning window behavior.
- `PushSubscription` and `PublicHash` expiration behavior over time.
- `User` validation callback behavior when `city` is nil/blank.
