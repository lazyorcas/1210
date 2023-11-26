# frozen_string_literal: true

class HomeController < ApplicationController
  layout :resolve_layout

  def index
    if current_user.present? && browser.device.mobile?
      redirect_to(meetups_path)
    end
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "home"
    else
      false
    end
  end
end
