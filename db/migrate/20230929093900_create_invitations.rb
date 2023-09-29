# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table(:invitations) do |t|
      t.references(:inviter, polymorphic: true)
      t.references(:invitee, polymorphic: true)
      t.boolean(:is_accepted)

      t.timestamps
    end
  end
end
