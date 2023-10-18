# frozen_string_literal: true

class HomeController < ApplicationController
  layout :resolve_layout

  def index
    if current_user.nil?
      return
    end

    redirect_to(meetups_path)
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "landing"
    else
      "application"
    end
  end
end
