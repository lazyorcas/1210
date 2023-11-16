# frozen_string_literal: true

class CurrentUserController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

  def friends
    ahoy.track("visited_friends")
    load_friends
    sort_friends
  end

  def update
    if current_user.update(current_user_params)
      if params[:city].present?
        redirect_to(things_path)
      else
        redirect_to(current_user_profile_path)
      end
    end
  end

  private

  def load_friends
    @friends = current_user.friends(params[:last_met])
  end

  def sort_friends
    @friends = @friends.sort_by(&:name)
  end

  def resolve_layout
    case action_name
    when "profile"
      "current_user/profile"
    when "friends"
      "current_user/friends"
    else
      "application"
    end
  end

  def current_user_params
    params.require(:user).permit(:avatar, :city)
  end
end
