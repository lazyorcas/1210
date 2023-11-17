# frozen_string_literal: true

class Idea::InvitationsController < SocialNetworkController
  def update
    load_idea_invitation
    if @idea_invitation.update(idea_invitation_params)
      turbo_stream
    end
  end

  private

  def load_idea_invitation
    @idea_invitation = idea_invitation_scope.find(params[:id])
  end

  def idea_invitation_scope
    Idea::Invitation.where(invitee: current_user)
  end

  def idea_invitation_params
    params.require(:idea_invitation).permit(:is_accepted)
  end
end
