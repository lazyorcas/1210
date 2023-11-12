# frozen_string_literal: true

class Idea < ApplicationRecord
  include FriendsOnly

  scope :ongoing, -> { where(status: [:looking_for_voters, :polling]) }
  scope :inactive,
    -> {
      joins(:invitations)
        .group("ideas.id")
        .having("MAX(invitations.updated_at) < ?", 3.days.ago)
    }

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

  has_many :comments, class_name: "Idea::Comment", as: :commentable

  validates_presence_of :title, :organizer

  after_commit :notify_of_new_idea, on: :create
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

  def notify_of_new_idea
    recipients = invitees.without_push_subscription

    if recipients.present?
      IdeaMailer
        .with(idea: self, recipients: recipients.map(&:email))
        .new_idea_notification
        .deliver_later
    end
  end

  def notify_voters_of_status_changed_to_polling
    PushSubscription.where(user: voters).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: "[Idea] #{title}",
        body: "🎉 You can start planning by adding options and voting on them.",
      )
    end

    recipients = voters.without_push_subscription
    if recipients.present?
      IdeaMailer
        .with(idea: self, recipients: recipients.map(&:email))
        .idea_status_changed_to_polling_notification
        .deliver_later
    end
  end

  private

  def main_user
    organizer
  end

  def seen_events
    Ahoy::Event
      .where(name: seen_event_name)
      .where("properties->>'idea_id' = ?", id.to_s)
  end
end
