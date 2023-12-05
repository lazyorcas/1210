# frozen_string_literal: true

class Thing < ApplicationRecord
  TYPES = [
    "Bar",
    "Cafe",
    "Exhibition",
    "Fair",
    "Film",
    "Leisure",
    "Music",
    "Restaurant",
    "Workshop",
  ].freeze

  default_scope { where(is_deleted: nil) }

  scope :time_of_day, ->(time_of_day) {
    case time_of_day
    when "breakfast"
      where(type: ["Cafe", "Restaurant"])
    when "lunch", "dinner"
      where(type: "Restaurant")
    when "morning", "afternoon"
      where.not(type: ["Music", "Restaurant", "Bar"])
    when "evening"
      where.not(type: ["Cafe", "Restaurant", "Exhibition"])
    end
  }

  scope :pending, ->(user) {
    where(city: [user.city, nil]).where.not(id: user.things_discovered)
  }

  has_many :invitations,
    class_name: "Thing::Invitation",
    as: :inviter

  has_many :accepted_invitations,
    -> { accepted },
    class_name: "Thing::Invitation",
    as: :inviter
  has_many :interestees, through: :accepted_invitations, source: :invitee, source_type: "User"

  has_many :meetups

  validates_presence_of :type, :title, :url, :image_url

  before_save :set_city_to_nil, if: -> { city.blank? }

  def soft_delete
    update(is_deleted: true)
  end

  private

  def set_city_to_nil
    self.city = nil
  end
end
