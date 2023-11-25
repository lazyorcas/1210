# frozen_string_literal: true

class User < ApplicationRecord
  scope :without_push_subscription, -> { left_joins(:push_subscriptions).where(push_subscriptions: { endpoint: nil }) }

  has_one_attached :avatar do |attachable|
    attachable.variant(:webp, resize_to_limit: [2000, 2000], convert: :webp)
  end

  belongs_to :inviter, class_name: "User", optional: true
  has_many :visits, class_name: "Ahoy::Visit"

  has_many :sent_invitations,
    class_name: "User::Invitation",
    as: :inviter
  has_many :received_invitations,
    class_name: "User::Invitation",
    as: :invitee

  has_many :organized_meetups, class_name: "Meetup", foreign_key: "organizer_id"

  has_many :meetup_invitations,
    class_name: "Meetup::Invitation",
    as: :invitee
  has_many :invited_meetups, through: :meetup_invitations, source: :inviter, source_type: "Meetup"

  has_many :accepted_meetup_invitations,
    -> { accepted },
    class_name: "Meetup::Invitation",
    as: :invitee
  has_many :accepted_meetups, through: :accepted_meetup_invitations, source: :inviter, source_type: "Meetup"

  has_many :pending_meetup_invitations,
    -> { pending },
    class_name: "Meetup::Invitation",
    as: :invitee
  has_many :pending_meetups, through: :pending_meetup_invitations, source: :inviter, source_type: "Meetup"

  has_many :declined_meetup_invitations,
    -> { declined },
    class_name: "Meetup::Invitation",
    as: :invitee
  has_many :declined_meetups, through: :declined_meetup_invitations, source: :inviter, source_type: "Meetup"

  has_many :ideas, foreign_key: "organizer_id"

  has_many :idea_invitations,
    class_name: "Idea::Invitation",
    as: :invitee
  has_many :invited_ideas, through: :idea_invitations, source: :inviter, source_type: "Idea"

  has_many :accepted_idea_invitations,
    -> { accepted },
    class_name: "Idea::Invitation",
    as: :invitee
  has_many :voting_ideas, through: :accepted_idea_invitations, source: :inviter, source_type: "Idea"

  has_many :declined_idea_invitations,
    -> { declined },
    class_name: "Idea::Invitation",
    as: :invitee
  has_many :declined_ideas, through: :declined_idea_invitations, source: :inviter, source_type: "Idea"

  has_many :idea_option_invitations,
    class_name: "Idea::Option::Invitation",
    as: :invitee
  has_many :invited_idea_options, through: :idea_option_invitations, source: :inviter, source_type: "Idea::Option"

  has_many :thing_invitations,
    class_name: "Thing::Invitation",
    as: :invitee
  has_many :things_discovered, through: :thing_invitations, source: :inviter, source_type: "Thing"

  has_many :accepted_thing_invitations,
    -> { accepted },
    class_name: "Thing::Invitation",
    as: :invitee
  has_many :interests, through: :accepted_thing_invitations, source: :inviter, source_type: "Thing"

  has_many :declined_thing_invitations,
    -> { declined },
    class_name: "Thing::Invitation",
    as: :invitee
  has_many :disinterests, through: :declined_thing_invitations, source: :inviter, source_type: "Thing"

  has_many :old_declined_thing_invitations,
    -> { declined.where("invitations.updated_at < ?", 1.month.ago) },
    class_name: "Thing::Invitation",
    as: :invitee
  has_many :old_disinterests, through: :old_declined_thing_invitations, source: :inviter, source_type: "Thing"

  has_many :availabilities

  validates_presence_of :name, :email, :time_zone

  validates :email,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :avatar,
    content_type: %r{\Aimage/.*\z},
    size: { less_than: 10.megabytes }

  passwordless_with :email

  after_create :create_session
  after_create :create_accepted_invitation, if: -> { inviter.present? }

  has_many :push_subscriptions

  def friend_ids
    sent_invitations.accepted.pluck(:invitee_id) +
      received_invitations.accepted.pluck(:inviter_id)
  end

  def friends(last_met = nil)
    friends = User.where(id: friend_ids)

    case last_met
    when "last_two_weeks"
      friends = friends.select do |friend|
        last_meetup = PastMeetup.between_users(self, friend).order(date: :desc).first
        last_meetup && 2.weeks.ago <= last_meetup.date
      end
    when "more_than_two_weeks_ago"
      friends = friends.select do |friend|
        last_meetup = PastMeetup.between_users(self, friend).order(date: :desc).first
        last_meetup && last_meetup.date < 2.weeks.ago
      end
    end

    friends
  end

  def friends_in_the_same_city
    # TODO: remove nil
    User.where(id: friend_ids, city: [city, nil])
  end

  private

  def create_session
    Passwordless::Session.create(authenticatable: self)
  end

  def create_accepted_invitation
    User::Invitation.create(
      inviter: inviter,
      invitee: self,
      is_accepted: true,
    )
  end
end
