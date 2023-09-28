# frozen_string_literal: true

class AddIsCancelledToMeetupAttendances < ActiveRecord::Migration[7.0]
  def up
    add_column(:meetup_attendances, :is_cancelled, :boolean)
    change_column_default(:meetup_attendances, :is_cancelled, false)
  end

  def down
    remove_column(:meetup_attendances, :is_cancelled)
  end
end
