# frozen_string_literal: true

module Dateful
  extend ActiveSupport::Concern

  def load_date
    @date = params[:date].to_date
  end
end
