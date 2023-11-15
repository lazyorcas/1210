# frozen_string_literal: true

class User::InvitationMailer < ApplicationMailer
  before_action do
    @invitation = params[:invitation]
  end

  def new_invitation_notification
    mail(
      subject: "✌️ You have a new friend request.",
      bcc: @invitation.invitee.email,
    )
  end
end
