# frozen_string_literal: true

class Meetup::InvitationsController < ApplicationController
  before_action :require_user!

  def update
    load_meetup_invitation
    if @meetup_invitation.update(meetup_invitation_params)
      turbo_stream
    end
  end

  private

  def load_meetup_invitation
    @meetup_invitation = meetup_invitation_scope.find(params[:id])
  end

  def meetup_invitation_scope
    Meetup::Invitation.where(invitee: current_user)
  end

  def meetup_invitation_params
    params.require(:meetup_invitation).permit(:is_accepted)
  end
end
