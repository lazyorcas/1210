# frozen_string_literal: true

class UsersController < ApplicationController
  layout :resolve_layout

  before_action :require_user!, only: [:friends]
  before_action :load_user, only: [:show]

  def new; end

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
    if current_user.present?
      if current_user.id == @user.id
        render("show_self")
      elsif current_user.friends.include?(@user)
        redirect_to(friends_path)
      else
        @invite = Invite.new(invitee_id: @user.id)

        render("show_signed_in_user")
      end
    else
      render("show_new_user")
    end
  end

  def friends
  end

  private

  def resolve_layout
    case action_name
    when "friends"
      "social_network"
    end
  end

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :time_zone, :inviter_id)
  end
end
