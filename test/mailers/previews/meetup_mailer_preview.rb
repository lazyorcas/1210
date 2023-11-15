# frozen_string_literal: true

class MeetupMailerPreview < ActionMailer::Preview
  def new_meetup_notification
    MeetupMailer
      .with(meetup: Meetup.last, recipients: [User.first])
      .new_meetup_notification
  end
end
