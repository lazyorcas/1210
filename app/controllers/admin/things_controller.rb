# frozen_string_literal: true

class Admin::ThingsController < AdminController
  layout :resolve_layout

  def index
    load_things
    filter_things_by_city if params[:city].present?
  end

  def new
    @thing = Thing.new
  end

  def create
    @thing = Thing.new(thing_params)

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
      "admin/things"
    else
      false
    end
  end

  def load_things
    @things = thing_scope
  end

  def filter_things_by_city
    @things = @things.where(city: [nil, params[:city]])
  end

  def load_thing
    @thing = thing_scope.find(params[:id])
  end

  def abstract_thing
    @thing = @thing.becomes(Thing)
  end

  def thing_scope
    Thing.all
  end

  def thing_params
    params.require(:thing).permit(:type, :title, :description, :tags, :city, :url, :image_url)
  end
end
