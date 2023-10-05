# frozen_string_literal: true

class IdeasController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

  def index
    load_user_to_ideas
  end

  def new
    @idea = Idea.new(user: current_user)
  end

  def create
    @idea = Idea.new(idea_params)
    @idea.user = current_user

    if @idea.save
      load_user_to_ideas
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

  def load_user_to_ideas
    @user_to_ideas = idea_scope.group_by(&:user).sort_by { |user, _| user.name }
  end

  def idea_scope
    Idea.where(id: current_user.idea_ids + current_user.invited_idea_ids)
  end

  def idea_params
    params.require(:idea).permit(:title, :is_done, invitee_ids: [])
  end
end
