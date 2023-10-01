# frozen_string_literal: true

class HomeController < ApplicationController
  layout "landing"

  def index
    if current_user.nil?
      return
    end

    redirect_to(meetups_path(date: Time.zone.today))
  end
end
