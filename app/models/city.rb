# frozen_string_literal: true

class City
  include ActiveModel::API

  class << self
    def all
      ["Barcelona", "Berlin", "Melbourne", "Munich"]
    end
  end
end
