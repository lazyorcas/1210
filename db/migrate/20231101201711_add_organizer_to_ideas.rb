# frozen_string_literal: true

class AddOrganizerToIdeas < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column(:ideas, :organizer_id, :bigint)
    add_index(:ideas, :organizer_id, algorithm: :concurrently)
  end
end
