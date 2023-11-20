# frozen_string_literal: true

module Dateful
  extend ActiveSupport::Concern

  def relative_to_today(date)
    if date == Time.zone.today
      "Today"
    elsif date == Time.zone.tomorrow
      "Tomorrow"
    elsif date >= Time.zone.today && date < 1.week.from_now.beginning_of_day
      date.strftime("%A")
    else
      "#{date.strftime("%a")}, #{date.strftime("%B")} #{date.day.ordinalize}"
    end
  end
end
