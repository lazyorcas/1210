# frozen_string_literal: true

class Idea::Comment < Comment
  default_scope { where(commentable_type: "Idea") }

  after_create :notify_idea_organizer_and_voters

  def idea
    commentable
  end

  private

  def notifiees
    [idea.organizer] + idea.voters - [author]
  end

  def notify_idea_organizer_and_voters
    PushSubscription.where(user: notifiees).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Idea] #{idea.title}",
        body: "#{author.name}: #{body}",
      )
    end
  end
end
