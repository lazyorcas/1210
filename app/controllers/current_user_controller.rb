# frozen_string_literal: true

class CurrentUserController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

  private

  def resolve_layout
    case action_name
    when "settings"
      "current_user/settings"
    else
      "application"
    end
  end
end
