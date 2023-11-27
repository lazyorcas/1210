# frozen_string_literal: true

class ThingsController < SocialNetworkController
  layout :resolve_layout

  before_action :load_type_filters, only: [:interesting, :filter]
  before_action :load_user_filters, only: [:interesting, :filter]

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
    filter_things_by_types if @type_filters.present?
    filter_things_by_users if @user_filters.present?
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

  def load_type_filters
    @type_filters = params[:type].reject(&:blank?) if params[:type].present?
  end

  def filter_things_by_types
    @things = @things.where(type: @type_filters)
  end

  def load_user_filters
    @user_filters = params[:user_id].reject(&:blank?) if params[:user_id].present?
  end

  def filter_things_by_users
    @things = @things.joins(:interestees).where({ users: { id: @user_filters } }).distinct
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
