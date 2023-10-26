# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/idea_mailer
class Idea::OptionMailerPreview < ActionMailer::Preview
  def new_option_notification
    Idea::OptionMailer
      .with(idea_option: Idea::Option.last)
      .new_option_notification
  end
end
