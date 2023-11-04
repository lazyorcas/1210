# frozen_string_literal: true

class Meetup < ApplicationRecord
  include FriendsOnly

  default_scope { where(is_deleted: false) }
  scope :deleted, -> { unscoped.where(is_deleted: true) }
  scope :upcoming,
    -> {
      where(
        "date > :today OR (date = :today AND :now <= end_time)",
        today: Time.zone.today,
        now: Time.zone.now.strftime("%H:%M"),
      )
    }

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

  has_many :comments, class_name: "Meetup::Comment", as: :commentable

  has_one :memory

  validates_presence_of :title, :date, :organizer

  validates :start_time,
    :end_time,
    format: { with: /\A([0-1]?[0-9]|2[0-3]):[0-5][0-9]\z/ },
    if: -> { start_time.present? || end_time.present? }

  validates :date,
    format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }

  def upcoming?
    date >= Time.zone.today
  end

  def soft_delete
    self.is_deleted = true
    save
  end

  def create_memory
    Memory.create(meetup: self)
  end

  def relative_day
    if date == Time.zone.today
      "Today"
    elsif date == Time.zone.tomorrow
      "Tomorrow"
    elsif date >= Time.zone.today && date <= 1.week.from_now
      date.strftime("%A")
    else
      "#{date.strftime("%B")} #{date.day.ordinalize}"
    end
  end

  def seen_invitees
    User.where(id: seen_events.includes(:visit).pluck("ahoy_visits.user_id"))
  end

  def seen_event_name
    "saw_meetup"
  end

  def seen_event_properties
    { meetup_id: id }
  end

  private

  def main_user
    organizer
  end

  def seen_events
    Ahoy::Event
      .where(name: seen_event_name)
      .where("properties->>'meetup_id' = ?", id.to_s)
  end
end
