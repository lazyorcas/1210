# frozen_string_literal: true

class Idea < ApplicationRecord
  include FriendsOnly

  scope :ongoing, -> { where(status: [:looking_for_voters, :polling]) }

  enum status: { looking_for_voters: 0, deleted: -1, polled: 1, polling: 2 }

  belongs_to :organizer, class_name: "User"
  belongs_to :thing, optional: true

  has_many :invitations,
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :invitees, through: :invitations, source: :invitee, source_type: "User"

  has_many :accepted_invitations,
    -> { accepted },
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :voters, through: :accepted_invitations, source: :invitee, source_type: "User"

  has_many :pending_invitations,
    -> { acceptable },
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :pending_invitees, through: :pending_invitations, source: :invitee, source_type: "User"

  has_many :options, class_name: "Idea::Option", as: :pollable

  validates_presence_of :title, :organizer

  after_update :notify_voters_of_status_changed_to_polling, if: -> { saved_change_to_status? && polling? }

  def soft_delete
    deleted!
    save
  end

  def seen_invitees
    User.where(id: seen_events.includes(:visit).pluck("ahoy_visits.user_id"))
  end

  def seen_event_name
    "saw_idea"
  end

  def seen_event_properties
    { idea_id: id }
  end

  private

  def main_user
    organizer
  end

  def notify_voters_of_status_changed_to_polling
    PushSubscription.where(user: voters).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Idea] #{title}",
        body: "🎉 You can start planning by adding options and voting on them.",
      )
    end

    IdeaMailer
      .with(idea: self, recipients: voters.without_push_subscription.to_a)
      .idea_status_changed_to_polling_notification.deliver_later(wait: 5.minutes)
  end

  def seen_events
    Ahoy::Event
      .where(name: seen_event_name)
      .where("properties->>'idea_id' = ?", id.to_s)
  end
end
