# frozen_string_literal: true

class AddStatusToIdeas < ActiveRecord::Migration[7.0]
  def up
    add_column(:ideas, :status, :integer)
    change_column_default(:ideas, :status, 0)
  end

  def down
    remove_column(:ideas, :status)
  end
end
