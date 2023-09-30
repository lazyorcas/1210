# frozen_string_literal: true

class DropMeetupAttendances < ActiveRecord::Migration[7.0]
  def change
    drop_table(:meetup_attendances)
  end
end
