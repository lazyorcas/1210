# frozen_string_literal: true

class Idea::Option::Invitation < Invitation
  default_scope { where(inviter_type: "Idea::Option", invitee_type: "User") }

  after_create :notify_invitee, if: -> { idea_option.notify? }
  after_update :notify_idea_organizer_and_voters, if: :is_accepted

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

  def notify_idea_organizer_and_voters
    PushSubscription.where(user: [idea.organizer] + idea.voters).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Idea] #{idea.title}",
        body: "👍 #{invitee.name} - #{idea_option.title}",
      )
    end
  end
end
