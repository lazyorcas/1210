# frozen_string_literal: true

class Idea::Option::Invitation < Invitation
  default_scope { where(inviter_type: "Idea::Option", invitee_type: "User") }

  after_create :notify_invitee

  def idea_option
    inviter
  end

  def idea
    idea_option.idea
  end

  def notify_invitee
    invitee.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Idea] #{idea.title}",
        body: "😎 New option added. Check it out!",
      )
    end
  end
end
