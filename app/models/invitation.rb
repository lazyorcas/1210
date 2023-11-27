# frozen_string_literal: true

class Invitation < ApplicationRecord
  self.abstract_class = true
  self.table_name = "invitations"

  belongs_to :inviter, polymorphic: true
  belongs_to :invitee, polymorphic: true, optional: true

  scope :acceptable, -> { where(is_accepted: [nil, false]) }
  scope :pending, -> { where(is_accepted: nil) }
  scope :accepted, -> { where(is_accepted: true) }
  scope :declined, -> { where(is_accepted: false) }

  def accept
    update(is_accepted: true)
  end
end
