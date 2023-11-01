# frozen_string_literal: true

class User::InvitationsController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

  def create
    @user_invitation = User::Invitation.new(
      inviter: current_user,
      invitee_id: create_user_invitation_params[:invitee_id],
    )

    if @user_invitation.save
      redirect_to(user_invitations_path)
    end
  end

  def update
    load_user_invitation
    if @user_invitation.update(update_user_invitation_params)
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

  def load_user_invitation
    @user_invitation = user_invitation_scope.find(params[:id])
  end

  def user_invitation_scope
    User::Invitation.where(invitee: current_user)
  end

  def create_user_invitation_params
    params.require(:user_invitation).permit(:invitee_id)
  end

  def update_user_invitation_params
    params.require(:user_invitation).permit(:is_accepted)
  end
end
