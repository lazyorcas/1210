# frozen_string_literal: true

class Meetup::Invitation < Invitation
  default_scope { where(inviter_type: "Meetup", invitee_type: "User") }

  after_update :notify_organizer, if: -> { is_accepted }

  private

  def notify_organizer
    inviter.organizer.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: inviter.title,
        body: "#{invitee.name} is joining!",
      )
    end
  end
end
