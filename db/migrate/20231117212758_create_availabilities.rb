# frozen_string_literal: true

class CreateAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table(:availabilities) do |t|
      t.belongs_to(:user)
      t.date(:date)
      t.integer(:time_of_day)

      t.timestamps

      t.index(:date)
    end
  end
end
