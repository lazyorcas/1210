# frozen_string_literal: true

class Meetup::Title
  include ActiveModel::API

  class << self
    def all
      Rails.application.config_for("models/meetup/titles")
    end
  end
end
