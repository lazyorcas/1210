# frozen_string_literal: true

class AddLastActivityAtToIdeas < ActiveRecord::Migration[7.0]
  def up
    add_column(:ideas, :last_activity_at, :timestamp)
    change_column_default(:ideas, :last_activity_at, -> { "CURRENT_TIMESTAMP" })
  end

  def down
    remove_column(:ideas, :last_activity_at)
  end
end
