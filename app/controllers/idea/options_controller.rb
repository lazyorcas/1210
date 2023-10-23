# frozen_string_literal: true

class Idea::OptionsController < ApplicationController
  before_action :require_user!

  def new
    @idea_option = Idea::Option.new
  end

  def create
    load_idea

    @idea_option = Idea::Option.new(idea_option_params)
    @idea_option.pollable = @idea

    if @idea_option.save
      turbo_stream
    end
  end

  private

  def load_idea
    @idea = idea_scope.find(params[:idea_id])
  end

  def idea_scope
    Idea.polling.where(id: current_user.idea_ids + current_user.invited_idea_ids)
  end

  def idea_option_params
    params.require(:idea_option).permit(:title)
  end
end
