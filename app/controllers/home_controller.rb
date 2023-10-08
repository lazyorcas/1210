# frozen_string_literal: true

class HomeController < ApplicationController
  layout :resolve_layout

  def index
    if current_user.nil?
      return
    end

    redirect_to(meetups_path(date: Time.zone.today))
  end

  def install
    @device_type = browser.platform.android? ? "android" : "other"
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "landing"
    end
  end
end
