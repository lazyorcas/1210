# frozen_string_literal: true

class CreateMeetups < ActiveRecord::Migration[7.0]
  def change
    create_table(:meetups) do |t|
      t.string(:title)
      t.string(:description)
      t.date(:date)
      t.string(:start_time)
      t.string(:end_time)
      t.boolean(:is_deleted, default: false)

      t.belongs_to(:organizer, class_name: "User")

      t.timestamps

      t.index(:date)
      t.index(:is_deleted)
    end
  end
end
