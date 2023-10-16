# frozen_string_literal: true

class Meetup < ApplicationRecord
  include FriendsOnly
  include TimeZoned

  default_scope { where(is_deleted: false) }
  scope :deleted, -> { unscoped.where(is_deleted: true) }

  belongs_to :organizer, class_name: "User"
  has_many :invitations,
    class_name: "Meetup::Invitation",
    as: :inviter
  has_many :invitees, through: :invitations, source: :invitee, source_type: "User"

  has_many :accepted_invitations,
    -> { where(is_accepted: true) },
    class_name: "Meetup::Invitation",
    as: :inviter
  has_many :attendees, through: :accepted_invitations, source: :invitee, source_type: "User"

  has_one :memory

  validates_presence_of :title, :date, :organizer

  validates :start_time,
    :end_time,
    format: { with: /\A([0-1]?[0-9]|2[0-3]):[0-5][0-9]\z/ },
    if: -> { start_time.present? || end_time.present? }

  validates :date,
    format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }

  after_create :notify_invitees, if: :today_or_future?

  def today_or_future?
    date >= Time.zone.today
  end

  def soft_delete
    self.is_deleted = true
    save
  end

  def local_start_time
    if local?
      start_time
    else
      organizer_start_time = start_time.in_time_zone(time_zone)
      organizer_start_time.in_time_zone(Time.zone).to_s(:time)
    end
  end

  def local_end_time
    if local?
      end_time
    else
      organizer_end_time = end_time.in_time_zone(time_zone)
      organizer_end_time.in_time_zone(Time.zone).to_s(:time)
    end
  end

  def create_memory
    Memory.create(meetup: self)
  end

  private

  def relative_day
    if date == Time.zone.today
      "Today"
    elsif date == Time.zone.tomorrow
      "Tomorrow"
    else
      date.strftime("%A")
    end
  end

  def notify_invitees
    invitees.each do |invitee|
      invitee.push_subscriptions.each do |push_subscription|
        PushNotificationJob.perform_later(
          push_subscription: push_subscription,
          title: "#{title} - #{organizer.name}",
          body: "#{relative_day}, #{local_start_time} - #{local_end_time}",
        )
      end
    end
  end

  def time_zone
    organizer.time_zone
  end

  def main_user
    organizer
  end
end
