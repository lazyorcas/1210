# frozen_string_literal: true

class AvailabilityGroup::ThingsController < SocialNetworkController
  def index
    load_things
    load_users_in_availability_group
    build_thing_users_pairs
    reject_empty_thing_users_pairs
    sort_thing_users_pairs
  end

  def show
    load_thing
  end

  private

  def load_things
    @things = thing_scope.time_of_day(params[:time_of_day])
  end

  def load_users_in_availability_group
    @users = current_user
      .friends_in_the_same_city
      .includes(:interests)
      .joins(:availabilities)
      .where(
        availabilities: {
          date: params[:date],
          time_of_day: params[:time_of_day],
        },
      )
  end

  def build_thing_users_pairs
    @thing_users_pairs = @things.map do |thing|
      [
        thing,
        @users.filter do |user|
          user.interests.include?(thing)
        end,
      ]
    end
  end

  def reject_empty_thing_users_pairs
    @thing_users_pairs.reject! { |_, users| users.empty? }
  end

  def sort_thing_users_pairs
    @thing_users_pairs.sort_by! { |thing, _| thing.title }
  end

  def load_thing
    @thing = thing_scope.find(params[:id])
  end

  def thing_scope
    current_user.interests
  end
end
