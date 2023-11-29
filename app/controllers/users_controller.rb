# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_mobile!

  def create
    load_user_invitation_public_hash
    load_user_invitation
    load_inviter

    @user = User.new(user_params.except(:user_invitation_public_hash_value))
    @user.inviter = @inviter

    if @user.save
      if @user_invitation.present?
        @user_invitation.update(invitee: @user, is_accepted: true)
      end

      @session = build_passwordless_session(@user)
      if @session.save
        sign_in(@session)
        redirect_to(root_path)
      else
        flash[:error] = I18n.t("passwordless.sessions.create.error")
        render(:new, status: :unprocessable_entity)
      end
    else
      flash[:error] = @user.errors.first.full_message
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def load_user_invitation_public_hash
    @user_invitation_public_hash = User::Invitation::PublicHash.find_by(
      value: user_params[:user_invitation_public_hash_value],
    )
  end

  def load_user_invitation
    @user_invitation = @user_invitation_public_hash&.user_invitation
  end

  def load_inviter
    @inviter = @user_invitation&.inviter
  end

  def user_params
    params.require(:user).permit(:name, :email, :city, :time_zone, :user_invitation_public_hash_value)
  end
end
