# frozen_string_literal: true

class Idea::OptionMailerPreview < ActionMailer::Preview
  def new_option_notification
    Idea::OptionMailer
      .with(idea_option: Idea::Option.last, recipients: [User.first])
      .new_option_notification
  end
end
