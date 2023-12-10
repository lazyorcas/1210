# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/availability_mailer
class AvailabilityMailerPreview < ActionMailer::Preview
  def weekly_reminder
    AvailabilityMailer
      .with(recipients: [User.first])
      .weekly_reminder
  end
end
