# frozen_string_literal: true

class Memory < ApplicationRecord
  MAX_FILE_SIZE = 10.megabytes

  belongs_to :meetup
  has_many_attached :photos do |attachable|
    attachable.variant(:webp, resize_to_limit: [2000, 2000], convert: :webp)
  end

  validates_uniqueness_of :meetup_id
  validate :file_sizes_less_than_max, if: -> { photos.attached? }

  after_create :notify_meetup_attendees

  private

  def file_sizes_less_than_max
    photos.each do |photo|
      if photo.blob.byte_size > MAX_FILE_SIZE
        errors.add(:photos, "File size must be less than 10MB")
      end
    end
  end

  def notify_meetup_attendees
    ([meetup.organizer] + meetup.attendees).each do |user|
      user.push_subscriptions.each do |push_subscription|
        PushNotificationJob.perform_later(
          push_subscription: push_subscription,
          title: meetup.title,
          body: "You can now add photos.",
        )
      end
    end
  end
end
