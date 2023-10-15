# frozen_string_literal: true

class PastMeetupsController < ApplicationController
  before_action :require_user!

  def new
    @past_meetup = PastMeetup.new(organizer: current_user)
  end

  def create
    @past_meetup = PastMeetup.new(past_meetup_params)
    @past_meetup.organizer = current_user

    if @past_meetup.save
      turbo_stream
    end
  end

  private

  def past_meetup_params
    params
      .require(:past_meetup)
      .permit(:title, :date, invitee_ids: [])
  end
end
