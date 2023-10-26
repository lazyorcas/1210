# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/meetup_mailer
class MeetupMailerPreview < ActionMailer::Preview
  def new_meetup_notification
    MeetupMailer
      .with(meetup: Meetup.last)
      .new_meetup_notification
  end
end
