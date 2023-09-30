# frozen_string_literal: true

class Meetup < ApplicationRecord
  default_scope { where(is_deleted: false) }
  scope :deleted, -> { unscoped.where(is_deleted: true) }

  belongs_to :organizer, class_name: "User"
  has_many :invitations, as: :inviter

  has_many :meetup_attendances
  has_many :attendees, class_name: "User", through: :meetup_attendances, source: :user

  validates_presence_of :title, :date, :start_time, :end_time

  validates :start_time,
    :end_time,
    format: { with: /\A([0-1]?[0-9]|2[0-3]):[0-5][0-9]\z/ }

  validates :date,
    format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }

  def soft_delete
    self.is_deleted = true
    save
  end
end
