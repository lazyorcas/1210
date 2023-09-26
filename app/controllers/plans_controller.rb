# frozen_string_literal: true

class PlansController < ApplicationController
  include Dateful

  layout "social_network"

  before_action :require_user!
  before_action :load_date
  before_action :load_meetups, only: [:index]

  def index; end

  private

  def load_organized_meetups
    @organized_meetups = current_user
      .organized_meetups
      .where(date: @date)
  end

  def load_attended_meetups
    @attended_meetups = current_user
      .attended_meetups
      .where(date: @date)
  end

  def load_meetups
    load_organized_meetups
    load_attended_meetups

    @meetups = (@organized_meetups + @attended_meetups).sort_by(&:start_time)
  end
end
