# frozen_string_literal: true

class User::InvitationsController < SocialNetworkController
  def create
    @user_invitation = User::Invitation.new(
      inviter: current_user,
      invitee_id: create_user_invitation_params[:invitee_id],
    )

    if @user_invitation.save
      redirect_to(current_user_friends_path)
    end
  end

  def update
    load_user_invitation
    if @user_invitation.update(update_user_invitation_params)
      redirect_to(current_user_friends_path)
    end
  end

  private

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
