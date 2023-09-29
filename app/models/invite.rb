# frozen_string_literal: true

class Invite < ApplicationRecord
  enum :invite_type, { friend_request: 0 }

  belongs_to :inviter, class_name: "User"
  belongs_to :invitee, class_name: "User"

  validates_presence_of :invite_type, :inviter

  scope :friend_requests, -> { where(invite_type: :friend_request) }
  scope :accepted, -> { where(is_accepted: true) }
  scope :pending, -> { where(is_accepted: nil) }

  def accept
    update(is_accepted: true)
  end
end
