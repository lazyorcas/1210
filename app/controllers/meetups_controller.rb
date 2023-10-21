# frozen_string_literal: true

class MeetupsController < ApplicationController
  layout :resolve_layout

  before_action :require_user!

  after_action :track_saw_meetups, only: [:index]

  def index
    load_meetups
    order_meetups
    build_date_meetups
    sort_date_meetups
  end

  def new
    @meetup = Meetup.new(organizer: current_user)
  end

  def create
    @meetup = Meetup.new(meetup_params)
    @meetup.organizer = current_user

    if @meetup.save
      redirect_to(meetups_path)
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
    else
      "application"
    end
  end

  def track_saw_meetups
    invited_meetups = @meetups & current_user.invited_meetups

    invited_meetups.each do |meetup|
      unless meetup.seen_invitees.exists?(current_user.id)
        ahoy.track(meetup.seen_event_name, meetup.seen_event_properties)
      end
    end
  end

  def load_current_user_meetup
    @meetup = current_user.organized_meetups.find(params[:id])
  end

  def load_meetup
    @meetup = meetup_scope.find(params[:id])
  end

  def load_meetups
    @meetups = meetup_scope
  end

  def order_meetups
    @meetups.order!(:date, :start_time)
  end

  def build_date_meetups
    @date_meetups = @meetups.group_by(&:date)
  end

  def sort_date_meetups
    @date_meetups.keys.sort!
  end

  def meetup_scope
    Meetup
      .where(id: current_user.organized_meetup_ids + current_user.invited_meetup_ids)
      .upcoming
  end

  def meetup_params
    params
      .require(:meetup)
      .permit(:title, :description, :date, :start_time, :end_time, invitee_ids: [])
  end
end
