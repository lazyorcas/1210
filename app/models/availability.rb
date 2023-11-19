# frozen_string_literal: true

class Availability < ApplicationRecord
  scope :upcoming, -> { where("date >= ?", Time.zone.today) }

  enum time_of_day: { breakfast: 0, morning: 1, lunch: 2, afternoon: 3, dinner: 4, evening: 5 }

  belongs_to :user

  validates_presence_of :date, :time_of_day
end
