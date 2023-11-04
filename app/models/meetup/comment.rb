# frozen_string_literal: true

class Meetup::Comment < Comment
  default_scope { where(commentable_type: "Meetup") }

  after_create :notify_meetup_invitees

  def meetup
    commentable
  end

  def notify_meetup_invitees
    PushSubscription.where(user_id: meetup.invitee_ids).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Meetup] #{meetup.title}",
        body: "#{author.name}: #{body}",
      )
    end
  end
end
