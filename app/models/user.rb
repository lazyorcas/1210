# frozen_string_literal: true

class User < ApplicationRecord
  has_many :sent_invites, class_name: "Invite", foreign_key: "inviter_id"
  has_many :received_invites, class_name: "Invite", foreign_key: "invitee_id"

  has_many :meetup_attendances
  has_many :attended_meetups, through: :meetup_attendances, source: :meetup
  has_many :organized_meetups, class_name: "Meetup", foreign_key: "organizer_id"

  validates_presence_of :name, :email, :time_zone

  validates :email,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  passwordless_with :email

  after_create :create_session
  after_create :create_accepted_friend_request, if: -> { inviter_id.present? }

  def friend_ids
    sent_invites.friend_requests.accepted.pluck(:invitee_id) +
      received_invites.friend_requests.accepted.pluck(:inviter_id)
  end

  def friends
    User.where(id: friend_ids)
  end

  private

  def create_session
    Passwordless::Session.create(authenticatable: self)
  end

  def create_accepted_friend_request
    Invite.create(
      invite_type: :friend_request,
      is_accepted: true,
      inviter_id: inviter_id,
      invitee_id: id,
    )
  end
end
