# frozen_string_literal: true

class Thing < ApplicationRecord
  TYPES = [
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

  has_many :invitations,
    class_name: "Thing::Invitation",
    as: :inviter

  has_many :accepted_invitations,
    -> { accepted },
    class_name: "Thing::Invitation",
    as: :inviter
  has_many :interestees, through: :accepted_invitations, source: :invitee, source_type: "User"

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
