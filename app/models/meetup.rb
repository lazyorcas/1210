# frozen_string_literal: true

class Meetup < ApplicationRecord
  default_scope { where(is_deleted: false) }
  scope :deleted, -> { unscoped.where(is_deleted: true) }

  belongs_to :organizer, class_name: "User"
  has_many :invitations, as: :inviter

  has_many :accepted_invitations, -> { where(is_accepted: true) }, class_name: "Invitation", as: :inviter
  has_many :attendees, through: :accepted_invitations, source: :invitee, source_type: "User"

  validates_presence_of :title, :date, :start_time, :end_time

  after_create :create_invitations

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

  def create_invitations
    organizer.friends.each do |user|
      Invitation.create(inviter: self, invitee: user)
    end
  end
end
