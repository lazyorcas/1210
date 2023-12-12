# frozen_string_literal: true

class Thing < ApplicationRecord
  TYPES = [
    "Bar",
    "Cafe",
    "Dish",
    "Exhibition",
    "Fair",
    "Film",
    "Leisure",
    "Music",
    "Restaurant",
    "Workshop",
  ].freeze

  USER_TYPES = ["Dish"].freeze

  default_scope { where(is_deleted: nil) }

  scope :time_of_day, ->(time_of_day) {
    case time_of_day
    when "breakfast"
      where(type: ["Cafe", "Restaurant"])
    when "lunch"
      where(type: "Restaurant")
    when "morning", "afternoon"
      where.not(type: ["Music", "Restaurant", "Dish", "Bar"])
    when "dinner"
      where(type: ["Restaurant", "Dish"])
    when "evening"
      where.not(type: ["Cafe", "Restaurant", "Dish", "Exhibition"])
    end
  }

  scope :pending, ->(user) {
    where(city: [user.city, nil]).where.not(id: user.things_discovered + user.things)
  }

  belongs_to :owner, class_name: "User", optional: true

  has_many :invitations,
    class_name: "Thing::Invitation",
    as: :inviter

  has_many :accepted_invitations,
    -> { accepted },
    class_name: "Thing::Invitation",
    as: :inviter
  has_many :interestees, through: :accepted_invitations, source: :invitee, source_type: "User"

  has_many :availability_invitations,
    class_name: "Thing::Availability::Invitation",
    as: :inviter

  has_many :meetups

  has_one_attached :image do |attachable|
    attachable.variant(:webp, resize_to_limit: [2000, 2000], convert: :webp)
  end

  validates_presence_of :image_url, if: -> { image.nil? }
  validates_presence_of :image, if: -> { image_url.nil? }

  validates :image,
    content_type: %r{\Aimage/.*\z},
    size: { less_than: 10.megabytes }

  validates_presence_of :type, :title

  before_save :set_city_to_nil, if: -> { city.blank? }

  def soft_delete
    update(is_deleted: true)
  end

  private

  def set_city_to_nil
    self.city = nil
  end
end
