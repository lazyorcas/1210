# frozen_string_literal: true

class MeetupsController < ApplicationController
  include Dateful

  layout :resolve_layout

  before_action :require_user!
  before_action :load_date, only: [:index, :new, :create]

  def index
    load_organized_meetups
    load_invited_meetups
    @meetups = (@organized_meetups + @invited_meetups).sort_by(&:start_time)
  end

  def new
    @meetup = Meetup.new
  end

  def create
    @meetup = Meetup.new(meetup_params)
    @meetup.organizer_id = current_user.id
    @meetup.date = @date

    if @meetup.save
      turbo_stream
    end
  end

  def edit
    load_meetup
  end

  def update
    load_meetup
    @meetup.update(meetup_params)
    turbo_stream
  end

  def destroy
    load_meetup
    if @meetup.soft_delete
      turbo_stream
    end
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "meetups"
    end
  end

  def load_organized_meetups
    @organized_meetups = current_user.organized_meetups.where(date: @date)
  end

  def load_invited_meetups
    @invited_meetups = current_user.invited_meetups.where(date: @date)
  end

  def load_meetup
    @meetup = current_user.organized_meetups.find(params[:id])
  end

  def meetup_params
    params.require(:meetup).permit(:title, :description, :start_time, :end_time)
  end
end
