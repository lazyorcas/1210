# frozen_string_literal: true

class IdeasController < ApplicationController
  layout :resolve_layout

  def index
    load_user_ideas
  end

  def new
    @idea = Idea.new(user: current_user)
  end

  def create
    @idea = Idea.new(idea_params)
    @idea.user = current_user

    if @idea.save
      load_user_ideas
      turbo_stream
    end
  end

  def edit
    load_idea
  end

  def update
    load_idea
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

  def load_idea
    @idea = current_user.ideas.find(params[:id])
  end

  def load_user_ideas
    ideas = current_user.ideas + current_user.invited_ideas
    @user_ideas = ideas.group_by(&:user)
  end

  def idea_params
    params.require(:idea).permit(:title, :is_done, invitee_ids: [])
  end
end
