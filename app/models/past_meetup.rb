# frozen_string_literal: true

class PastMeetup < Meetup
  default_scope { where("date < ?", Time.zone.today) }

  scope :between_users, ->(user_a, user_b) {
    joins(:accepted_invitations)
      .where({ invitations: { invitee_id: [user_a, user_b] } })
      .group("meetups.id")
      .having("COUNT(invitations.id) = 2 OR meetups.organizer_id IN (?)", [user_a, user_b])
  }

  after_create :create_memory
end
