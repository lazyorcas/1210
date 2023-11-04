# frozen_string_literal: true

class Meetup::Comment < Comment
  default_scope { where(commentable_type: "Meetup") }

  after_create :notify_meetup_organizer_and_invitees

  def meetup
    commentable
  end

  private

  def notifiees
    [meetup.organizer] + meetup.invitees - [author]
  end

  def notify_meetup_organizer_and_invitees
    PushSubscription.where(user: notifiees).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Meetup] #{meetup.title}",
        body: "#{author.name}: #{body}",
      )
    end
  end
end
