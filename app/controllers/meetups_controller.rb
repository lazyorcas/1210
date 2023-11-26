# frozen_string_literal: true

class MeetupsController < SocialNetworkController
  layout :resolve_layout

  after_action :track_saw_meetups, only: [:index]

  def index
    load_meetups
    filter_meetups
    order_meetups
    build_date_meetups_pairs
    sort_date_meetups_pairs
  end

  def new
    @meetup = Meetup.new
    @meetup.thing_id = params[:thing_id]
    @meetup.date = params[:date]
    @meetup.title = @meetup.thing&.title
    assign_current_user_to_meetup_organizer
  end

  def create
    @meetup = Meetup.new(meetup_params)
    assign_current_user_to_meetup_organizer

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
      "main_tab"
    else
      "modal"
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

  def assign_current_user_to_meetup_organizer
    @meetup.organizer = current_user
  end

  def load_meetups
    @meetups = meetup_scope
  end

  def filter_meetups
    if params[:filter] == "declined"
      filter_by_declined_meetups
    else
      filter_by_going_or_pending_meetups
    end
  end

  def filter_by_going_or_pending_meetups
    @meetups = @meetups.where.not(id: current_user.declined_meetups)
  end

  def filter_by_declined_meetups
    @meetups = @meetups.where(id: current_user.declined_meetups)
  end

  def order_meetups
    @meetups.order!(:date, :start_time)
  end

  def build_date_meetups_pairs
    @date_meetups_pairs = @meetups.group_by(&:date)
  end

  def sort_date_meetups_pairs
    @date_meetups_pairs.keys.sort!
  end

  def meetup_scope
    Meetup
      .where(id: current_user.organized_meetups + current_user.invited_meetups)
      .upcoming
  end

  def meetup_params
    params
      .require(:meetup)
      .permit(:title, :description, :date, :start_time, :end_time, :thing_id, invitee_ids: [])
  end
end
