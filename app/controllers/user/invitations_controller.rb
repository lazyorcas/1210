# frozen_string_literal: true

class User::InvitationsController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

  def create
    @invitation = User::Invitation.new
    @invitation.inviter = current_user
    @invitation.invitee = User.find(user_invitation_params[:invitee_id])

    if @invitation.save
      redirect_to(user_invitations_path)
    end
  end

  def update
    @invitation = User::Invitation.find_by(
      id: params[:id],
      invitee: current_user,
    )
    @invitation.is_accepted = user_invitation_params[:is_accepted]

    if @invitation.save
      redirect_to(user_invitations_path)
    end
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "user/invitations"
    else
      "application"
    end
  end

  def user_invitation_params
    params.require(:user_invitation).permit(:invitee_id, :is_accepted)
  end
end
