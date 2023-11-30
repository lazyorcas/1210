# frozen_string_literal: true

class ThingMailer < ApplicationMailer
  before_action do
    @recipients = params[:recipients]
  end

  def weekly_announcement
    mail(
      subject: "🏙️ What's happening in the city this week?",
      bcc: @recipients,
    )
  end
end
