# frozen_string_literal: true

class HomeController < ApplicationController
  layout "landing"

  before_action :redirect_to_today_plans, if: -> { current_user.present? }

  def index; end

  private

  def redirect_to_today_plans
    redirect_to(plans_path(date: Time.zone.today))
  end
end
