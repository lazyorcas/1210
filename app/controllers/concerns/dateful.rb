# frozen_string_literal: true

module Dateful
  extend ActiveSupport::Concern

  def load_date
    @date = params[:date].to_date
  end

  def date_in_past?
    @date < Time.zone.today
  end
end
