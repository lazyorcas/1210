# frozen_string_literal: true

class CreateMeetupAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table(:meetup_attendances) do |t|
      t.belongs_to(:user)
      t.belongs_to(:meetup)

      t.timestamps
    end
  end
end
