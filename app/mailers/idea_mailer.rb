# frozen_string_literal: true

class IdeaMailer < ApplicationMailer
  before_action do
    @idea = params[:idea]
  end

  def new_idea_notification
    mail(
      subject: "🤩 #{@idea.user.name} suggests a new meetup idea!",
      bcc: @idea.invitees.map(&:email),
    )
  end

  def status_changed_to_polling_notification
    mail(
      subject: "😎 The idea you are interested in is ready for planning!",
      bcc: @idea.invitees.map(&:email),
    )
  end
end
