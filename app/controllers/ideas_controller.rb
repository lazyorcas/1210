# frozen_string_literal: true

class IdeasController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

  after_action :track_saw_ideas, only: [:index]

  def index
    load_ideas
    order_ideas
  end

  def new
    @idea = Idea.new(user: current_user)
  end

  def create
    @idea = Idea.new(idea_params)
    @idea.user = current_user

    if @idea.save
      turbo_stream
    end
  end

  def show
    load_idea
  end

  def edit
    load_current_user_idea
  end

  def update
    load_current_user_idea
    if @idea.update(idea_params)
      turbo_stream
    end
  end

  def destroy
    load_current_user_idea
    if @idea.soft_delete
      turbo_stream
    end
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "ideas"
    else
      "application"
    end
  end

  def track_saw_ideas
    name = "saw_idea"
    invited_ideas = @ideas & current_user.invited_ideas

    invited_ideas.each do |idea|
      properties = { idea_id: idea.id }

      unless idea.seen_events.exists?(name: name, properties: properties)
        ahoy.track(name, properties)
      end
    end
  end

  def load_current_user_idea
    @idea = current_user.ideas.find(params[:id])
  end

  def load_idea
    @idea = idea_scope.find(params[:id])
  end

  def load_ideas
    @ideas = idea_scope
  end

  def order_ideas
    @ideas.order!(created_at: :desc)
  end

  def idea_scope
    Idea.where(id: current_user.idea_ids + current_user.invited_idea_ids)
  end

  def idea_params
    params.require(:idea).permit(:title, :description, :is_done, invitee_ids: [])
  end
end
