# frozen_string_literal: true

class MemoriesController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

  def index
    load_memories
    order_memories
  end

  def show
    load_memory
  end

  def update
    load_memory
    if @memory.update(memory_params)
      turbo_stream
    end
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "memories"
    else
      "application"
    end
  end

  def load_memory
    @memory = memory_scope.find(params[:id])
  end

  def load_memories
    @memories = memory_scope
  end

  def order_memories
    @memories
      .includes!(:meetup)
      .order!("meetups.date DESC, meetups.start_time DESC")
  end

  def memory_scope
    Memory.where(meetup_id: current_user.organized_meetup_ids + current_user.accepted_meetup_ids)
  end

  def memory_params
    params.require(:memory).permit(photos: [])
  end
end
