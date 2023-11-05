# frozen_string_literal: true

class Memory < ApplicationRecord
  belongs_to :meetup
  has_many_attached :photos do |attachable|
    attachable.variant(:webp, resize_to_limit: [2000, 2000], convert: :webp)
  end

  validates_uniqueness_of :meetup_id
  validates :photos,
    content_type: %r{\Aimage/.*\z},
    size: { less_than: 10.megabytes }

  after_create :notify_meetup_organizer_and_attendees

  def notify_meetup_organizer_and_attendees
    PushSubscription.where(user: [meetup.organizer] + meetup.attendees).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Memory] #{meetup.title}",
        body: "📷 You can now add photos to this memory.",
      )
    end
  end
end
