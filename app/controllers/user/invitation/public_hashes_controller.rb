# frozen_string_literal: true

class User::Invitation::PublicHashesController < ApplicationController
  layout :resolve_layout

  def show
    load_user_invitation_public_hash

    if @user_invitation_public_hash.nil?
      head(:not_found)
      return
    end

    # new user
    if current_user.nil?
      redirect_to(new_user_path(user_invitation_public_hash_value: params[:id]))
      return
    end

    # already friend
    load_user_invitation
    load_inviter

    if current_user.friend_ids.include?(@inviter.id)
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

  def load_user_invitation_public_hash
    @user_invitation_public_hash = User::Invitation::PublicHash.find_by(value: params[:id])
  end

  def load_user_invitation
    @user_invitation = @user_invitation_public_hash.user_invitation
  end

  def load_inviter
    @inviter = @user_invitation.inviter
  end
end
