# frozen_string_literal: true

class PastMeetup < Meetup
  default_scope { where("date < ?", Time.zone.today) }

  after_create :create_memory
  after_create :accept_invitations

  private

  def accept_invitations
    invitations.each(&:accept)
  end
end
