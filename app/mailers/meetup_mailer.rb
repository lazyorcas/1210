# frozen_string_literal: true

class MeetupMailer < ApplicationMailer
  before_action do
    @meetup = params[:meetup]
    @recipients = params[:recipients]
  end

  def new_meetup_notification
    mail(
      subject: "🥳 #{@meetup.organizer.name} has invited you to a new meetup!",
      bcc: @recipients,
    )
  end
end
