# frozen_string_literal: true

class Meetup < ApplicationRecord
  default_scope { where(is_deleted: false) }
  scope :deleted, -> { unscoped.where(is_deleted: true) }

  belongs_to :organizer, class_name: "User"
  has_many :invitations,
    class_name: "Meetup::Invitation",
    as: :inviter
  has_many :invitees, through: :invitations, source: :invitee, source_type: "User"

  has_many :accepted_invitations,
    -> { where(is_accepted: true) },
    class_name: "Meetup::Invitation",
    as: :inviter
  has_many :attendees, through: :accepted_invitations, source: :invitee, source_type: "User"

  validates_presence_of :title, :date, :start_time, :end_time, :organizer

  before_commit :limit_invitees_to_organizer_friends, if: -> { invitees.present? }, on: [:create, :update]
  before_create :set_invitees_to_organizer_friends, if: -> { !invitees.present? }

  validates :start_time,
    :end_time,
    format: { with: /\A([0-1]?[0-9]|2[0-3]):[0-5][0-9]\z/ }

  validates :date,
    format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }

  def soft_delete
    self.is_deleted = true
    save
  end

  private

  def limit_invitees_to_organizer_friends
    self.invitees &= organizer.friends
  end

  def set_invitees_to_organizer_friends
    self.invitees = organizer.friends
  end
end
