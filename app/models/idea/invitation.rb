# frozen_string_literal: true

class Idea::Invitation < Invitation
  default_scope { where(inviter_type: "Idea", invitee_type: "User") }

  after_create :notify_invitee
  after_update :notify_organizer, if: :is_accepted
  after_commit :update_idea_last_activity_at, on: [:create, :update]

  def idea
    inviter
  end

  def notify_invitee
    invitee.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Idea] #{idea.title}",
        body: "💭 Let #{idea.organizer.name} know if you are interested.",
      )
    end
  end

  def notify_organizer
    idea.organizer.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Idea] #{idea.title}",
        body: "#{invitee.name} is interested!",
      )
    end
  end

  private

  def update_idea_last_activity_at
    idea.update_last_activity_at_to_now
  end
end
