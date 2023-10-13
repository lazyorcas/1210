# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
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

  def show
    load_user

    if current_user.present?
      if current_user == @user
        render("show_self")
      elsif current_user.friends.find_by(id: @user.id)
        redirect_to(users_invitations_path)
      else
        @invitation = current_user.received_invitations.find_by(inviter: @user)
        @invitation ||= current_user.sent_invitations.find_by(invitee: @user)
        @invitation ||= User::Invitation.new(inviter: current_user, invitee: @user)

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
