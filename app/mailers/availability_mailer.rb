# frozen_string_literal: true

class AvailabilityMailer < ApplicationMailer
  before_action do
    @recipients = params[:recipients]
  end

  def weekly_reminder
    mail(
      subject: "👋 Reminder to meet your friends this week",
      bcc: @recipients,
    )
  end
end
