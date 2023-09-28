# frozen_string_literal: true

class PlansController < ApplicationController
  include Dateful

  layout "social_network"

  before_action :require_user!
  before_action :load_date

  def index
    @meetups = meetups.sort_by(&:start_time)
  end

  private

  def organized_meetups
    current_user.organized_meetups.where(date: @date)
  end

  def attended_meetups
    current_user.attended_meetups.where(date: @date)
  end

  def meetups
    organized_meetups + attended_meetups
  end
end
