# frozen_string_literal: true

class PushSubscription < ApplicationRecord
  default_scope { where("expiration_time IS NULL OR expiration_time > ?", Time.zone.now.to_f) }

  belongs_to :user

  validates :endpoint, presence: true, uniqueness: true
  validates :p256dh_key, presence: true
  validates :auth_key, presence: true
end
