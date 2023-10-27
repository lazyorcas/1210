# frozen_string_literal: true

class Meetup::InvitationsController < ApplicationController
  before_action :require_user!

  def update
    @invitation = Meetup::Invitation.find_by(
      id: params[:id],
      invitee: current_user,
    )
    @invitation.is_accepted = meetup_invitation_params[:is_accepted]

    if @invitation.save
      turbo_stream
    end
  end

  private

  def meetup_invitation_params
    params.require(:meetup_invitation).permit(:is_accepted)
  end
end
