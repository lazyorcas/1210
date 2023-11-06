# frozen_string_literal: true

module ThingsHelper
  def interesting_things_path
    things_path(interesting: true)
  end
end
