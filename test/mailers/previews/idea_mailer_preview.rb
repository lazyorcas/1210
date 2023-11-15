# frozen_string_literal: true

class IdeaMailerPreview < ActionMailer::Preview
  def new_idea_notification
    IdeaMailer
      .with(idea: Idea.last, recipients: [User.first])
      .new_idea_notification
  end

  def idea_status_changed_to_polling_notification
    IdeaMailer
      .with(idea: Idea.last, recipients: [User.first])
      .idea_status_changed_to_polling_notification
  end
end
