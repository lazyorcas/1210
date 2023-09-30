# frozen_string_literal: true

class User::Invitation < Invitation
  after_create :create_inviter_meetup_invitations, if: -> { inviter.present? && invitee.present? && is_accepted }

  after_commit :create_inviter_meetup_invitations, on: :update
  after_commit :create_invitee_meetup_invitations, on: :update

  private

  def create_inviter_meetup_invitations
    inviter.organized_meetups.each do |meetup|
      unless Invitation.find_by(inviter: meetup, invitee: invitee)
        Invitation.create(inviter: meetup, invitee: invitee)
      end
    end
  end

  def create_invitee_meetup_invitations
    invitee.organized_meetups.each do |meetup|
      unless Invitation.find_by(inviter: meetup, invitee: inviter)
        Invitation.create(inviter: meetup, invitee: inviter)
      end
    end
  end
end
