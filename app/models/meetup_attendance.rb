# frozen_string_literal: true

class MeetupAttendance < ApplicationRecord
  belongs_to :meetup
  belongs_to :user
end
