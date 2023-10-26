# frozen_string_literal: true

class User < ApplicationRecord
  scope :without_push_subscription, -> { left_joins(:push_subscriptions).where(push_subscriptions: { endpoint: nil }) }

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
    -> { where(is_accepted: true) },
    class_name: "Meetup::Invitation",
    as: :invitee
  has_many :accepted_meetups, through: :accepted_meetup_invitations, source: :inviter, source_type: "Meetup"

  has_many :ideas

  has_many :idea_invitations,
    class_name: "Idea::Invitation",
    as: :invitee
  has_many :invited_ideas, through: :idea_invitations, source: :inviter, source_type: "Idea"

  has_many :accepted_idea_invitations,
    -> { where(is_accepted: true) },
    class_name: "Idea::Invitation",
    as: :invitee
  has_many :voting_ideas, through: :accepted_idea_invitations, source: :inviter, source_type: "Idea"

  has_many :idea_option_invitations,
    class_name: "Idea::Option::Invitation",
    as: :invitee
  has_many :invited_idea_options, through: :idea_option_invitations, source: :inviter, source_type: "Idea::Option"

  validates_presence_of :name, :email, :time_zone

  validates :email,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  passwordless_with :email

  after_create :create_session
  after_create :create_accepted_invitation, if: -> { inviter.present? }

  has_many :push_subscriptions

  def friend_ids
    sent_invitations.accepted.pluck(:invitee_id) +
      received_invitations.accepted.pluck(:inviter_id)
  end

  def friends
    User.where(id: friend_ids)
  end

  def admin?
    id == 1
  end

  def last_meetup_with(user)
    last_meetup_invitation = Meetup::Invitation
      .where(invitee: [user, self])
      .or(
        Meetup::Invitation.where(
          inviter: user.organized_meetups,
          invitee: self,
        ),
      ).or(
        Meetup::Invitation.where(
          inviter: organized_meetups,
          invitee: user,
        ),
      )
      .order(:created_at)
      .last

    last_meetup_invitation&.meetup&.created_at
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
