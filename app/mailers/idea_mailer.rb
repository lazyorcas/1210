# frozen_string_literal: true

class IdeaMailer < ApplicationMailer
  before_action do
    @idea = params[:idea]
    @invitees = @idea.invitees.without_push_subscription
    @voters = @idea.voters.without_push_subscription
  end

  def new_idea_notification
    if @invitees.present?
      mail(
        subject: "🤩 #{@idea.user.name} suggests a new meetup idea!",
        bcc: @invitees.map(&:email),
      )
    end
  end

  def status_changed_to_polling_notification
    if @voters.present?
      mail(
        subject: "😎 The idea you are interested in is ready for planning!",
        bcc: @voters.map(&:email),
      )
    end
  end
end
