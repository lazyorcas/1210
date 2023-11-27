# frozen_string_literal: true

class User::InvitationsController < SocialNetworkController
  def new
    @user_invitation = User::Invitation.new(inviter: current_user)
  end

  def create
    @user_invitation = User::Invitation.new(inviter: current_user)

    if @user_invitation.save
      turbo_stream
    end
  end

  def update
    load_user_invitation
    @user_invitation.is_accepted = user_invitation_params[:is_accepted]
    @user_invitation.invitee = current_user

    if @user_invitation.save
      redirect_to(root_path)
    end
  end

  private

  def resolve_layout
    case action_name
    when "new"
      "modal"
    end
  end

  def load_user_invitation
    @user_invitation = User::Invitation.find(params[:id])
  end

  def user_invitation_params
    params.require(:user_invitation).permit(:is_accepted)
  end
end
