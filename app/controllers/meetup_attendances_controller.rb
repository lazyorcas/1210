# frozen_string_literal: true

class MeetupAttendancesController < ApplicationController
  before_action :require_user!, only: [:create]

  def create
    @meetup_attendance = MeetupAttendance.new(meetup_attendance_params)
    @meetup_attendance.user_id = current_user.id

    if @meetup_attendance.save
      turbo_stream
    end
  end

  private

  def meetup_attendance_params
    params.require(:meetup_attendance).permit(:meetup_id)
  end
end
