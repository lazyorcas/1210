# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/idea_mailer
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
