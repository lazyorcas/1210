# frozen_string_literal: true

class MeetupAttendancesController < ApplicationController
  before_action :require_user!, only: [:create]

  def create
    permitted_params = required_params.permit(:meetup_id)

    @meetup_attendance = MeetupAttendance.new(permitted_params)
    @meetup_attendance.user_id = current_user.id

    if @meetup_attendance.save
      turbo_stream
    end
  end

  def update
    permitted_params = required_params.permit(:is_cancelled)

    load_meetup_attendance
    @meetup_attendance.update(permitted_params)

    if @meetup_attendance.save
      turbo_stream
    end
  end

  private

  def load_meetup_attendance
    @meetup_attendance = current_user.meetup_attendances.unscoped.find(params[:id])
  end

  def required_params
    params.require(:meetup_attendance)
  end
end
