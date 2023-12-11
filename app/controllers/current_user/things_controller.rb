# frozen_string_literal: true

class CurrentUser::ThingsController < SocialNetworkController
  layout :resolve_layout

  def index
    load_things
    order_things
  end

  def new
    @thing = thing_scope.build
  end

  def create
    @thing = thing_scope.build
    @thing.attributes = thing_params

    if @thing.save
      abstract_thing
      turbo_stream
    end
  end

  def edit
    load_thing
    abstract_thing
  end

  def update
    load_thing
    abstract_thing
    if @thing.update(thing_params)
      turbo_stream
    end
  end

  def destroy
    load_thing
    abstract_thing
    @thing.soft_delete
    turbo_stream
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "side_tab"
    when "new", "edit"
      "modal"
    end
  end

  def load_things
    @things = thing_scope.includes(:interestees)
  end

  def order_things
    @things = @things.order(updated_at: :desc)
  end

  def load_thing
    @thing = thing_scope.find(params[:id])
  end

  def abstract_thing
    @thing = @thing.becomes(Thing)
  end

  def thing_scope
    Thing.where(owner: current_user, city: current_user.city)
  end

  def thing_params
    params.require(:thing).permit(:type, :title, :description, :tags, :image)
  end
end
