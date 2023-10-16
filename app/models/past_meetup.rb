# frozen_string_literal: true

class PastMeetup < Meetup
  default_scope { where("date < ?", Time.zone.today) }

  after_create :create_memory
  after_create :accept_invitations

  validate :in_past

  private

  def in_past
    errors.add(:date, "can't be today or future") if today_or_future?
  end

  def accept_invitations
    invitations.each(&:accept)
  end
end
