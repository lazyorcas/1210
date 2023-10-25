# frozen_string_literal: true

class MeetupMailer < ApplicationMailer
  before_action do
    @meetup = params[:meetup]
    @invitees = @meetup.invitees.without_push_subscription
  end

  def new_meetup_notification
    if @invitees.present?
      mail(
        subject: "🥳 #{@meetup.organizer.name} has invited you to a new meetup!",
        bcc: @invitees.map(&:email),
      )
    end
  end
end
