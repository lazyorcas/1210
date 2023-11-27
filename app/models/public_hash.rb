# frozen_string_literal: true

require "securerandom"

class PublicHash < ApplicationRecord
  default_scope { where("? < expired_at", Time.zone.now) }

  belongs_to :hashable, polymorphic: true

  validates_presence_of :expired_at

  before_create :auto_generate_value

  def expire
    self.expired_at = Time.zone.now
    save
  end

  private

  def auto_generate_value
    self.value = SecureRandom.hex(32)
  end
end
