# frozen_string_literal: true

class Thing::Invitation < Invitation
  default_scope { where(inviter_type: "Thing", invitee_type: "User") }

  # after_create :notify_thing_interestees_who_are_friends, if: :is_accepted

  def thing
    inviter
  end

  def notify_thing_interestees_who_are_friends
    PushSubscription.where(user: thing.interestees & invitee.friends).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[#{thing.type}] #{thing.title}",
        body: "🤩 #{invitee.name} is also interested!",
      )
    end
  end
end
