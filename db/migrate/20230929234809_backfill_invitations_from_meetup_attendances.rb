# frozen_string_literal: true

class BackfillInvitationsFromMeetupAttendances < ActiveRecord::Migration[7.0]
  # def up
  #   MeetupAttendance.unscoped.find_each do |meetup_attendance|
  #     Invitation.create(
  #       inviter: meetup_attendance.meetup,
  #       invitee: meetup_attendance.user,
  #       is_accepted: !meetup_attendance.is_cancelled,
  #       created_at: meetup_attendance.created_at,
  #       updated_at: meetup_attendance.updated_at,
  #     )

  #     sleep(0.01) # throttle
  #   end
  # end
end
