# frozen_string_literal: true

class AddOwnerToThings < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column(:things, :owner_id, :bigint)
    add_index(:things, :owner_id, algorithm: :concurrently)
  end
end
