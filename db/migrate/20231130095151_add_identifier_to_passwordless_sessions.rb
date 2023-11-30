# frozen_string_literal: true

class AddIdentifierToPasswordlessSessions < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column(:passwordless_sessions, :identifier, :string)
    add_index(:passwordless_sessions, :identifier, unique: true, algorithm: :concurrently)
  end
end
