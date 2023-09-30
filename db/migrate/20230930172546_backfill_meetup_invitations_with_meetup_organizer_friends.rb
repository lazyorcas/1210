# frozen_string_literal: true

class BackfillMeetupInvitationsWithMeetupOrganizerFriends < ActiveRecord::Migration[7.0]
  def change
    Meetup.find_each do |meetup|
      meetup.organizer.friends.each do |user|
        unless Invitation.find_by(inviter: meetup, invitee: user)
          Invitation.create(inviter: meetup, invitee: user)
        end
      end

      sleep(0.01) # throttle
    end
  end
end
