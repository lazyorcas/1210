# frozen_string_literal: true

class AddIsDeletedIndexToIdeas < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index(:ideas, :is_deleted, algorithm: :concurrently)
  end
end
