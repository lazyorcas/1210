# frozen_string_literal: true

class AvailabilitiesController < SocialNetworkController
  layout "main_tab"

  def index
    ahoy.track("visited_availabilities")
    load_availability_groups
    load_friend_availabilities
    build_availability_group_users_pairs
    reject_empty_availability_group_users_pairs
  end

  private

  def load_availability_groups
    @availability_groups =
      current_user
        .availabilities
        .select(:date, :time_of_day)
        .distinct
        .order(:date, :time_of_day)
  end

  def load_friend_availabilities
    @friend_availabilities = Availability.where(user: current_user.friends_in_the_same_city).includes(:user)
  end

  def build_availability_group_users_pairs
    @availability_group_users_pairs = @availability_groups.map do |availability_group|
      [
        availability_group,
        @friend_availabilities.filter do |availability|
          availability.date == availability_group.date &&
            availability.time_of_day == availability_group.time_of_day
        end.map(&:user),
      ]
    end
  end

  def reject_empty_availability_group_users_pairs
    @availability_group_users_pairs.reject! { |_, users| users.empty? }
  end
end
