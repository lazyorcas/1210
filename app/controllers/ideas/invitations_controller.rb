# frozen_string_literal: true

class Ideas::InvitationsController < ApplicationController
  before_action :require_user!

  def update
    @invitation = Idea::Invitation.find_by(
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
    params.require(:idea_invitation).permit(:is_accepted)
  end
end
