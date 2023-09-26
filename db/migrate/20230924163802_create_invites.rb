# frozen_string_literal: true

class CreateInvites < ActiveRecord::Migration[7.0]
  def change
    create_table(:invites) do |t|
      t.integer(:invite_type, default: 0)
      t.boolean(:is_accepted)

      t.belongs_to(:inviter, class_name: "User")
      t.belongs_to(:invitee, class_name: "User")

      t.timestamps
    end
  end
end
