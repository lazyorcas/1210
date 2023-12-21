# frozen_string_literal: true

class User::InvitationsController < SocialNetworkController
  def new
    @user_invitation = User::Invitation.new(inviter: current_user)
  end

  def create
    @user_invitation = User::Invitation.create(inviter: current_user)
  end

  private

  def resolve_layout
    case action_name
    when "new"
      "modal"
    end
  end
end
