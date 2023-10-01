# frozen_string_literal: true

class HomeController < ApplicationController
  layout "landing"

  def index
    if current_user.nil?
      return
    end

    if today_meetups.empty?
      redirect_to(today_meetups_path)
    else
      redirect_to(today_schedule_path)
    end
  end

  private

  def today_schedule_path
    schedule_path(date: Time.zone.today)
  end

  def today_meetups_path
    meetups_path(date: Time.zone.today)
  end

  def organized_today_meetups
    current_user.organized_meetups.where(date: Time.zone.today)
  end

  def accepted_today_meetups
    current_user.accepted_meetups.where(date: Time.zone.today)
  end

  def today_meetups
    organized_today_meetups + accepted_today_meetups
  end
end
