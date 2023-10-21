# frozen_string_literal: true

class Idea < ApplicationRecord
  include FriendsOnly

  default_scope { where(is_done: false, is_deleted: false) }
  scope :deleted, -> { unscoped.where(is_deleted: true) }

  belongs_to :user

  has_many :invitations,
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :invitees, through: :invitations, source: :invitee, source_type: "User"

  has_many :upvotes,
    -> { where(is_accepted: true) },
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :upvoters, through: :upvotes, source: :invitee, source_type: "User"

  has_many :pending_votes,
    -> { where(is_accepted: nil) },
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :pending_voters, through: :pending_votes, source: :invitee, source_type: "User"

  has_many :downvotes,
    -> { where(is_accepted: false) },
    class_name: "Idea::Invitation",
    as: :inviter
  has_many :downvoters, through: :downvotes, source: :invitee, source_type: "User"

  validates_presence_of :title, :user

  after_create :notify_invitees

  def pending_voters_and_downvoters
    pending_voters + downvoters
  end

  def soft_delete
    self.is_deleted = true
    save
  end

  def seen_invitees
    User.where(id: seen_events.joins(:visit).pluck("ahoy_visits.user_id"))
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
    invitees.each do |invitee|
      invitee.push_subscriptions.each do |push_subscription|
        PushNotificationJob.perform_later(
          push_subscription: push_subscription,
          title: title,
          body: "#{user.name} suggests this idea",
        )
      end
    end
  end

  def seen_events
    Ahoy::Event
      .where(name: seen_event_name)
      .where("properties->>'idea_id' = ?", id.to_s)
  end
end
