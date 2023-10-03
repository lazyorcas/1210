# frozen_string_literal: true

module TimeZoned
  extend ActiveSupport::Concern

  def local?
    ActiveSupport::TimeZone[Time.zone] == ActiveSupport::TimeZone[time_zone]
  end

  def time_zone
    raise NotImplementedError
  end
end
