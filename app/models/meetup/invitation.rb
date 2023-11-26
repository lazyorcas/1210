# frozen_string_literal: true

class Meetup::Invitation < Invitation
  include Invitation::IsComplete
  include Dateful

  default_scope { where(inviter_type: "Meetup", invitee_type: "User") }

  after_create :accept, if: -> { !meetup.upcoming? }
  after_create :notify_invitee, if: -> { meetup.upcoming? }
  after_update :notify_organizer, if: -> { is_accepted && meetup.upcoming? }

  def meetup
    inviter
  end

  def notify_invitee
    invitee.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Meetup] #{meetup.title} - #{meetup.organizer.name}",
        body: "#{relative_to_today(meetup.date)}, #{meetup.start_time} - #{meetup.end_time}",
      )
    end
  end

  def notify_organizer
    meetup.organizer.push_subscriptions.each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Meetup] #{meetup.title}",
        body: "#{invitee.name} is joining!",
      )
    end
  end
end
