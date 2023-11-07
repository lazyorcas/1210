# frozen_string_literal: true

class ThingsController < ApplicationController
  layout :resolve_layout

  before_action :require_user!
  before_action :require_admin!, except: [:index]

  def all
    @things = Thing.all
    render("index")
  end

  def index
    if current_user.city.nil?
      redirect_to(current_user_edit_path) and return
    end

    load_things
    filter_things_by_city
    filter_things_by_interests
    if params[:interesting].present?
      order_things
    else
      randomize_things
    end
  end

  def new
    @thing = Thing.new
  end

  def create
    @thing = Thing.new(thing_params)

    if @thing.save
      redirect_to(things_path)
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
      redirect_to(things_path)
    end
  end

  def destroy
    @thing.soft_delete
    redirect_to(things_path)
  end

  private

  def resolve_layout
    case action_name
    when "index", "all"
      "things"
    else
      "application"
    end
  end

  def load_things
    @things = thing_scope
  end

  def filter_things_by_city
    @things = @things.where(city: [nil, current_user.city])
  end

  def filter_things_by_interests
    @things =
      if params[:interesting].present?
        @things.where(id: current_user.interests)
      else
        @things
          .left_joins(:invitations)
          .where(invitations: { id: nil })
      end
  end

  def order_things
    @things.order!(:title)
  end

  def randomize_things
    @things.order!("RANDOM()")
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
