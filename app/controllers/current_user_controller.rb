# frozen_string_literal: true

class CurrentUserController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

  def update
    if current_user.update(current_user_params)
      redirect_to(things_path)
    end
  end

  private

  def resolve_layout
    case action_name
    when "settings"
      "current_user/settings"
    else
      "application"
    end
  end

  def current_user_params
    params.require(:user).permit(:city)
  end
end
