# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :inviter, polymorphic: true
  belongs_to :invitee, polymorphic: true

  scope :acceptable, -> { where(is_accepted: [nil, false]) }
  scope :pending, -> { where(is_accepted: nil) }
  scope :accepted, -> { where(is_accepted: true) }
  scope :declined, -> { where(is_accepted: false) }

  def accept
    update(is_accepted: true)
  end
end
