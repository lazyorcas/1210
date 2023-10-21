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
end
