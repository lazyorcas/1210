# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/thing_mailer
class ThingMailerPreview < ActionMailer::Preview
  def weekly_announcement
    ThingMailer
      .with(recipients: [User.first])
      .weekly_announcement
  end
end
