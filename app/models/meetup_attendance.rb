# frozen_string_literal: true

class MeetupAttendance < ApplicationRecord
  default_scope { where(is_cancelled: false) }
  scope :cancelled, -> { unscoped.where(is_cancelled: true) }

  belongs_to :meetup
  belongs_to :user
end
