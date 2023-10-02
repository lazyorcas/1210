# frozen_string_literal: true

class Meetups::InvitationsController < ApplicationController
  def update
    @invitation = Meetup::Invitation.find_by(
      id: params[:id],
      invitee: current_user,
    )
    @invitation.is_accepted = invitation_params[:is_accepted]

    if @invitation.save
      turbo_stream
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:is_accepted)
  end
end
