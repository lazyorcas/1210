# frozen_string_literal: true

class Idea::Option::InvitationsController < ApplicationController
  before_action :require_user!

  def update
    load_idea_option_invitation
    if @idea_option_invitation.update(idea_option_invitation_params)
      turbo_stream
    end
  end

  private

  def load_idea_option_invitation
    @idea_option_invitation = idea_option_invitation_scope.find(params[:id])
  end

  def idea_option_invitation_scope
    Idea::Option::Invitation.where(invitee: current_user)
  end

  def idea_option_invitation_params
    params.require(:idea_option_invitation).permit(:is_accepted)
  end
end
