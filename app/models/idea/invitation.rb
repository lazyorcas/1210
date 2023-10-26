# frozen_string_literal: true

class Idea::Invitation < Invitation
  default_scope { where(inviter_type: "Idea", invitee_type: "User") }

  after_create :notify_invitee

  def idea
    inviter
  end

  def notify_invitee
    invitee.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Idea] #{idea.title}",
        body: "💭 Let #{idea.user.name} know if you are interested.",
      )
    end
  end
end
