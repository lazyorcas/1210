# frozen_string_literal: true

class AddIsDeletedToIdeas < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    add_column(:ideas, :is_deleted, :boolean)
    change_column_default(:ideas, :is_deleted, false)
    Idea.unscoped.in_batches do |relation|
      relation.update_all(is_deleted: false)
      sleep(0.01) # throttle
    end
  end

  def down
    remove_column(:ideas, :is_deleted)
  end
end
