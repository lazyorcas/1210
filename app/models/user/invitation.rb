# frozen_string_literal: true

class User::Invitation < Invitation
  include Invitation::IsUnique
  include Invitation::IsBidirectional

  default_scope { where(inviter_type: "User", invitee_type: "User") }

  after_create :create_public_hash, if: -> { invitee.nil? }
  after_update :notify_inviter, if: :is_accepted
  after_update :expire_public_hash, if: :is_accepted

  has_one :public_hash, class_name: "User::Invitation::PublicHash", as: :hashable

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

  private

  def create_public_hash
    User::Invitation::PublicHash.create(hashable: self, expired_at: 24.hours.from_now)
  end

  def expire_public_hash
    public_hash.expire
  end
end
