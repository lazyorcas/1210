# frozen_string_literal: true

class Meetup::Title
  include ActiveModel::API

  attr_accessor :value, :label

  class << self
    def all
      Rails.application.config_for("models/meetup/titles").map do |title|
        Meetup::Title.new(value: title[:value], label: title[:label])
      end
    end

    def find_by_value(value)
      all.find { |title| title.value == value }
    end
  end
end
