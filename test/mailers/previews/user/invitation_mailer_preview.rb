# frozen_string_literal: true

class User::InvitationMailerPreview < ActionMailer::Preview
  def new_invitation_notification
    User::InvitationMailer
      .with(invitation: User::Invitation.last)
      .new_invitation_notification
  end
end
