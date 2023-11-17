# frozen_string_literal: true

class HomeController < ApplicationController
  layout "home"

  def index
    if current_user.present?
      redirect_to(meetups_path) and return
    end
  end
end
