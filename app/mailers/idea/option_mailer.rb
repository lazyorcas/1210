# frozen_string_literal: true

class Idea::OptionMailer < ApplicationMailer
  before_action do
    @idea_option = params[:idea_option]
    @voters = @idea_option.voters.without_push_subscription - [@idea_option.originator]
  end

  def new_option_notification
    if @voters.present?
      mail(
        subject: "😎 New voting option is added to an idea.",
        bcc: @voters.map(&:email),
      )
    end
  end
end
