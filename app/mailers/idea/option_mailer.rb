# frozen_string_literal: true

class Idea::OptionMailer < ApplicationMailer
  before_action do
    @idea_option = params[:idea_option]
    @recipients = params[:recipients]
  end

  def new_option_notification
    mail(
      subject: "😎 New voting option is added to an idea.",
      bcc: @recipients.map(&:email),
    )
  end
end
