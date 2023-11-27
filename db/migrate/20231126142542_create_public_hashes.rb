# frozen_string_literal: true

class CreatePublicHashes < ActiveRecord::Migration[7.0]
  def change
    create_table(:public_hashes) do |t|
      t.references(:hashable, polymorphic: true)
      t.string(:value)
      t.datetime(:expired_at)

      t.timestamps

      t.index(:value)
      t.index(:expired_at)
    end
  end
end
