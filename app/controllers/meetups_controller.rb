# frozen_string_literal: true

class MeetupsController < ApplicationController
  include Dateful

  layout :resolve_layout

  before_action :require_user!
  before_action :load_date, only: [:index, :new, :create]
  before_action :redirect_to_today, only: [:index, :new, :create], if: :date_in_past?

  def index
    load_meetups
    sort_meetups
  end

  def new
    @meetup = Meetup.new(organizer: current_user)
  end

  def create
    @meetup = Meetup.new(meetup_params)
    @meetup.organizer = current_user
    @meetup.date = @date

    if @meetup.save
      turbo_stream
    end
  end

  def show
    load_meetup
  end

  def edit
    load_current_user_meetup
  end

  def update
    load_current_user_meetup
    if @meetup.update(meetup_params)
      turbo_stream
    end
  end

  def destroy
    load_current_user_meetup
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

  def redirect_to_today
    redirect_to(meetups_path(date: Time.zone.today))
  end

  def load_current_user_meetup
    @meetup = current_user.organized_meetups.find(params[:id])
  end

  def load_meetup
    @meetup = meetup_scope.find(params[:id])
  end

  def load_meetups
    @meetups = meetup_scope.where(date: @date).to_a
  end

  def sort_meetups
    @meetups.sort_by(&:local_start_time)
  end

  def meetup_scope
    Meetup.where(id: current_user.organized_meetup_ids + current_user.invited_meetup_ids)
  end

  def meetup_params
    params
      .require(:meetup)
      .permit(:title, :description, :start_time, :end_time, invitee_ids: [])
  end
end
