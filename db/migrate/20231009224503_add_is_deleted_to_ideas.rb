# frozen_string_literal: true

class AddIsDeletedToIdeas < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    add_column(:ideas, :is_deleted, :boolean)
    change_column_default(:ideas, :is_deleted, false)
  end

  def down
    remove_column(:ideas, :is_deleted)
  end
end
