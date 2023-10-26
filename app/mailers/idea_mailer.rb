# frozen_string_literal: true

class IdeaMailer < ApplicationMailer
  before_action do
    @idea = params[:idea]
    @recipients = params[:recipients]
  end

  def new_idea_notification
    mail(
      subject: "🤩 #{@idea.user.name} suggests a new meetup idea!",
      bcc: @recipients.map(&:email),
    )
  end

  def idea_status_changed_to_polling_notification
    mail(
      subject: "😎 The idea you are interested in is ready for planning!",
      bcc: @recipients.map(&:email),
    )
  end
end
