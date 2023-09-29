# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :inviter, polymorphic: true
  belongs_to :invitee, polymorphic: true

  validates_presence_of :inviter, :invitee

  scope :pending, -> { where(is_accepted: nil) }
  scope :accepted, -> { where(is_accepted: true) }
  scope :denied, -> { where(is_accepted: false) }

  def accept
    self.is_accepted = true
    save
  end
end
