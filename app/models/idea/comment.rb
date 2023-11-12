# frozen_string_literal: true

class Idea::Comment < Comment
  default_scope { where(commentable_type: "Idea") }

  after_create :notify_idea_organizer_and_voters
  after_create :update_idea_last_activity_at

  def idea
    commentable
  end

  private

  def update_idea_last_activity_at
    idea.update_last_activity_at_to_now
  end

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
