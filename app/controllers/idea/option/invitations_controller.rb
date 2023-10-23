# frozen_string_literal: true

class Idea::Option::InvitationsController < ApplicationController
  before_action :require_user!

  def update
    @invitation = Idea::Option::Invitation.find_by(
      id: params[:id],
      invitee: current_user,
    )

    if @invitation.update(invitation_params)
      turbo_stream
    end
  end

  private

  def invitation_params
    params.require(:idea_option_invitation).permit(:is_accepted)
  end
end
