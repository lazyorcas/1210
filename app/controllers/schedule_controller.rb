# frozen_string_literal: true

class ScheduleController < ApplicationController
  include Dateful

  before_action :require_user!
  before_action :load_date

  def index
    load_organized_meetups
    load_accepted_meetups
    @meetups = (@organized_meetups + @accepted_meetups).sort_by(&:start_time)
  end

  private

  def load_organized_meetups
    @organized_meetups = current_user.organized_meetups.where(date: @date)
  end

  def load_accepted_meetups
    @accepted_meetups = current_user.accepted_meetups.where(date: @date)
  end
end
