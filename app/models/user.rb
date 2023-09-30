# frozen_string_literal: true

class User < ApplicationRecord
  has_many :visits, class_name: "Ahoy::Visit"

  has_many :sent_invitations,
    -> {
      where(inviter_type: "User", invitee_type: "User")
    },
    class_name: "Invitation",
    as: :inviter
  has_many :received_invitations,
    -> {
      where(inviter_type: "User", invitee_type: "User")
    },
    class_name: "Invitation",
    as: :invitee

  has_many :organized_meetups, class_name: "Meetup", foreign_key: "organizer_id"

  has_many :meetup_invitations,
    -> { where(inviter_type: "Meetup", invitee_type: "User") },
    class_name: "Invitation",
    as: :invitee
  has_many :invited_meetups, through: :meetup_invitations, source: :inviter, source_type: "Meetup"

  has_many :accepted_meetup_invitations,
    -> { where(inviter_type: "Meetup", invitee_type: "User", is_accepted: true) },
    class_name: "Invitation",
    as: :invitee
  has_many :accepted_meetups, through: :accepted_meetup_invitations, source: :inviter, source_type: "Meetup"

  validates_presence_of :name, :email, :time_zone

  validates :email,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  passwordless_with :email

  after_create :create_session
  after_create :create_accepted_invitation, if: -> { inviter_id.present? }

  def friend_ids
    sent_invitations.accepted.pluck(:invitee_id) +
      received_invitations.accepted.pluck(:inviter_id)
  end

  def friends
    User.where(id: friend_ids)
  end

  private

  def create_session
    Passwordless::Session.create(authenticatable: self)
  end

  def create_accepted_invitation
    inviter = User.find(inviter_id)

    User::Invitation.create(
      inviter: inviter,
      invitee: self,
      is_accepted: true,
    )
  end
end
