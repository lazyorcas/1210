# frozen_string_literal: true

class IdeasController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

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

  private

  def resolve_layout
    case action_name
    when "index"
      "ideas"
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
    params.require(:idea).permit(:title, :is_done, :is_deleted, invitee_ids: [])
  end
end
