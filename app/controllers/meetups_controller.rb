# frozen_string_literal: true

class MeetupsController < ApplicationController
  include Dateful

  layout :resolve_layout

  before_action :require_user!
  before_action :load_date, only: [:index, :new, :create]
  before_action :load_meetups, only: [:index]
  before_action :load_meetup, only: [:edit, :update, :destroy]

  def index; end

  def new
    @meetup = Meetup.new
  end

  def edit; end

  def create
    @meetup = Meetup.new(meetup_params)
    @meetup.organizer_id = current_user.id
    @meetup.date = @date

    @meetup.save

    turbo_stream
  end

  def update
    @meetup.update(meetup_params)

    turbo_stream
  end

  def destroy
    if @meetup.soft_delete
      turbo_stream
    end
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "social_network"
    end
  end

  def load_meetups
    @meetups = Meetup
      .where(date: @date, organizer_id: [current_user.id] + current_user.friend_ids)
      .order(:start_time)
  end

  def load_meetup
    @meetup = current_user.organized_meetups.find(params[:id])
  end

  def meetup_params
    params.require(:meetup).permit(:title, :description, :start_time, :end_time)
  end
end
