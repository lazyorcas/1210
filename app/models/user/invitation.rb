# frozen_string_literal: true

class User::Invitation < Invitation
  include Invitation::IsBidirectional

  default_scope { where(inviter_type: "User", invitee_type: "User") }

  after_create :notify_invitee
  after_update :notify_inviter, if: :is_accepted

  def notify_invitee_by_push
    invitee.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "Friend Request",
        body: "✌️ #{inviter.name} sent you a friend request!",
      )
    end
  end

  def notify_invitee_by_email
    User::InvitationMailer
      .with(invitation: self)
      .new_invitation_notification
      .deliver_later
  end

  def notify_invitee
    if invitee.push_subscriptions.any?
      notify_invitee_by_push
    else
      notify_invitee_by_email
    end
  end

  def notify_inviter
    inviter.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "Friend Request",
        body: "👍 #{invitee.name} accepted your friend request!",
      )
    end
  end
end
