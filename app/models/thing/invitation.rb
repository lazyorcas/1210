# frozen_string_literal: true

class Thing::Invitation < Invitation
  include Invitation::IsComplete
  include Invitation::IsUnique

  default_scope { where(inviter_type: "Thing", invitee_type: "User") }

  after_create :notify_thing_owner, if: -> { thing.owner.present? && is_accepted }

  def thing
    inviter
  end

  def notify_thing_owner
    thing.owner.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[#{thing.type}] #{thing.title}",
        body: "🤩 #{invitee.name} is interested!",
      )
    end
  end
end
