# frozen_string_literal: true

class City::ThingsController < SocialNetworkController
  # before_action :redirect_to_things_path, if: -> { current_user.present? }

  def index
    load_city
    load_things
    randomize_things
    ahoy.track("visited_city_things", { city: @city })
  end

  private

  def redirect_to_things_path
    redirect_to(things_path)
  end

  def load_city
    @city = params[:city_name].titleize
  end

  def load_things
    @things = thing_scope.where(city: @city)
  end

  def randomize_things
    @things.order!("RANDOM()")
  end

  def thing_scope
    Thing.all
  end
end
