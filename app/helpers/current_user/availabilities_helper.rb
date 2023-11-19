# frozen_string_literal: true

module CurrentUser::AvailabilitiesHelper
  def availability_dom_id(availability)
    "availability_#{availability.date}_#{availability.time_of_day}"
  end
end
