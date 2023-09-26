# frozen_string_literal: true

# This migration comes from passwordless (originally 20171104221735)
class CreatePasswordlessSessions < ActiveRecord::Migration[5.1]
  def change
    create_table(:passwordless_sessions) do |t|
      t.belongs_to(:authenticatable, polymorphic: true, index: { name: "authenticatable" })

      t.string(:token_digest, null: false)
      t.datetime(:timeout_at, null: false)
      t.datetime(:expires_at, null: false)
      t.datetime(:claimed_at)

      t.timestamps

      t.index(:token_digest)
    end
  end
end
