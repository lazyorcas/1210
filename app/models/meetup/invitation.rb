# frozen_string_literal: true

class Meetup::Invitation < Invitation
  default_scope { where(inviter_type: "Meetup", invitee_type: "User") }

  after_create :notify_invitee
  after_update :notify_organizer, if: -> { is_accepted && meetup.upcoming? }

  def meetup
    inviter
  end

  def notify_invitee
    invitee.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "#{meetup.title} - #{meetup.organizer.name}",
        body: "#{meetup.relative_day}, #{meetup.local_start_time} - #{meetup.local_end_time}",
      )
    end
  end

  def notify_organizer
    meetup.organizer.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: meetup.title,
        body: "#{invitee.name} is joining!",
      )
    end
  end
end
