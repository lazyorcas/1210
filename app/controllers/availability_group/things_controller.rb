# frozen_string_literal: true

class AvailabilityGroup::ThingsController < SocialNetworkController
  def index
    load_things
    load_users_in_availability_group
    build_thing_users_pairs
    reject_empty_thing_users_pairs
    load_current_user_available_accepted_things
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
      .includes(:available_accepted_things)
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
          user.interests.include?(thing) || thing.owner_id == user.id
        end,
      ]
    end
  end

  def reject_empty_thing_users_pairs
    @thing_users_pairs.reject! { |_, users| users.empty? }
  end

  def load_current_user_available_accepted_things
    @current_user_available_accepted_things =
      current_user
        .available_accepted_things
        .where(availabilities: {
          date: params[:date],
          time_of_day: params[:time_of_day],
        })
        .all
  end

  def sort_thing_users_pairs
    @thing_users_pairs.sort_by! do |thing, _|
      [@current_user_available_accepted_things.include?(thing) ? -1 : 0, thing.title]
    end
  end

  def load_thing
    @thing = thing_scope.find(params[:id])
  end

  def thing_scope
    Thing.where(id: current_user.interests + current_user.things)
  end
end
