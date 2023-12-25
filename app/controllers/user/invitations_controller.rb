# frozen_string_literal: true

class User::InvitationsController < SocialNetworkController
  def new
    @user_invitation = User::Invitation.new(inviter: current_user)
  end

  def create
    @user_invitation = User::Invitation.create(inviter: current_user)
  end

  def update
    load_invitation
    @user_invitation.invitee = current_user
    @user_invitation.is_accepted = true

    if @user_invitation.save
      redirect_to(current_user_friends_path)
    end
  end

  private

  def load_invitaiton
    @user_invitation = User::Invitation.find(params[:id])
  end

  def resolve_layout
    case action_name
    when "new"
      "modal"
    end
  end
end
