# frozen_string_literal: true

class ThingsController < SocialNetworkController
  layout :resolve_layout

  def index
    load_things
    filter_things_by_city
    filter_things_by_pending
    load_old_uninteresting_things if @things.empty?
    randomize_things
    ahoy.track("visited_things")
    track_things_are_empty
  end

  def interesting
    load_things
    filter_things_by_interests
    order_things
    ahoy.track("visited_interesting_things")
    track_things_are_empty
  end

  def show
    load_thing
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "main_tab"
    when "interesting"
      "side_tab"
    else
      "modal"
    end
  end

  def load_thing
    @thing = thing_scope.find(params[:id])
  end

  def load_things
    @things = thing_scope
  end

  def load_old_uninteresting_things
    @things = current_user.old_disinterests
  end

  def filter_things_by_city
    @things = @things.where(city: [nil, current_user.city])
  end

  def filter_things_by_interests
    @things = @things.where(id: current_user.interests)
  end

  def filter_things_by_pending
    @things = @things.where(id: Thing.pending(current_user))
  end

  def order_things
    @things.order!(:title)
  end

  def randomize_things
    @things.order!("RANDOM()")
  end

  def track_things_are_empty
    ahoy.track("saw_no_things") if @things.empty?
  end

  def thing_scope
    Thing.all
  end
end
