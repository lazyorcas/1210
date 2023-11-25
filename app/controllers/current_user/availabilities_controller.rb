# frozen_string_literal: true

class CurrentUser::AvailabilitiesController < SocialNetworkController
  layout false

  def index
    ahoy.track("visited_current_user_availabilities")
    set_availabilities_date_range
    load_availabilities
    build_date_availabilities_pairs
  end

  def create
    @availability = Availability.new(availability_params)
    @availability.user = current_user

    if @availability.save
      turbo_stream
    end
  end

  def destroy
    load_availability

    if @availability.destroy
      turbo_stream
    end
  end

  private

  def set_availabilities_date_range
    @date_range = Time.zone.now.to_date..7.days.from_now.to_date
  end

  def load_availabilities
    @availabilities = availability_scope.where(date: @date_range)
  end

  def build_date_availabilities_pairs
    @date_availabilities_pairs = @date_range.map do |date|
      [
        date,
        Availability.time_of_days.keys.map do |time_of_day|
          [
            time_of_day,
            @availabilities.find { |a| a.date == date && a.time_of_day == time_of_day } ||
              availability_scope.build(date: date, time_of_day: time_of_day),
          ]
        end,
      ]
    end
  end

  def load_availability
    @availability = availability_scope.find(params[:id])
  end

  def availability_scope
    current_user.availabilities
  end

  def availability_params
    params.require(:availability).permit(:date, :time_of_day)
  end
end
