# frozen_string_literal: true

class Idea < ApplicationRecord
  include FriendsOnly
  self.ignored_columns = ["is_done", "is_deleted"]

  scope :ongoing, -> { where(status: [:looking_for_voters, :polling]) }

  enum status: { looking_for_voters: 0, deleted: -1, polled: 1, polling: 2 }

  belongs_to :user

  has_many :invitations,
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :invitees, through: :invitations, source: :invitee, source_type: "User"

  has_many :accepted_invitations,
    -> { where(is_accepted: true) },
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :voters, through: :accepted_invitations, source: :invitee, source_type: "User"

  has_many :pending_invitations,
    -> { where(is_accepted: [false, nil]) },
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :pending_invitees, through: :pending_invitations, source: :invitee, source_type: "User"

  has_many :options, class_name: "Idea::Option", as: :pollable

  validates_presence_of :title, :user

  after_create :notify_invitees

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
    user
  end

  def notify_invitees
    PushSubscription.where(user: invitee_ids).each do |push_subscription|
      PushNotificationJob.perform_later(
        push_subscription: push_subscription,
        title: title,
        body: "#{user.name} suggests this idea",
      )
    end

    IdeaMailer.with(idea: self).new_idea_notification.deliver_later
  end

  def seen_events
    Ahoy::Event
      .where(name: seen_event_name)
      .where("properties->>'idea_id' = ?", id.to_s)
  end
end
