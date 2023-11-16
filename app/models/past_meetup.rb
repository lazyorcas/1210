# frozen_string_literal: true

class PastMeetup < Meetup
  default_scope { where("date < ?", Time.zone.today) }

  scope :between_users, ->(user_a, user_b) {
    joins(:accepted_invitations)
      .where('
      EXISTS (
        SELECT 1
        WHERE
          (meetups.organizer_id = :user_a AND invitations.invitee_id = :user_b)
          OR
          (meetups.organizer_id = :user_b AND invitations.invitee_id = :user_a)
      ) OR (
        EXISTS (
          SELECT 1
          WHERE invitations.invitee_id = :user_a
        )
        AND EXISTS (
          SELECT 1
          WHERE invitations.invitee_id = :user_b
        )
      )',
        user_a: user_a,
        user_b: user_b)
  }

  after_create :create_memory
end
