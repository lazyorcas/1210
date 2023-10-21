# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/idea_mailer
class IdeaMailerPreview < ActionMailer::Preview
  def new_idea_notification
    IdeaMailer
      .with(idea: Idea.first, invitees: [User.first])
      .new_idea_notification
  end
end
