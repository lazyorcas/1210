# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.create!(user_params)

    @session = Passwordless::Session
      .where(authenticatable_id: @user.id)
      .order(created_at: :desc).first

    sign_in(@session)

    redirect_to(plans_path)
  rescue StandardError
    redirect_to(root_path)
  end

  def show
    load_user

    if current_user.present?
      if current_user.id == @user.id
        render("show_self")
      elsif current_user.friends.include?(@user)
        redirect_to(users_invitations_path)
      else
        @invitation = current_user.received_friendships.find_by(inviter: @user)
        @invitation ||= current_user.sent_friendships.find_by(invitee: @user)
        @invitation ||= Invitation.new(inviter: current_user, invitee: @user)

        render("show_signed_in_user")
      end
    else
      render("show_new_user")
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :time_zone, :inviter_id)
  end
end
