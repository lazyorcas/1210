# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table(:users) do |t|
      t.string(:name)
      t.string(:email)
      t.string(:time_zone)

      t.belongs_to(:inviter, class_name: "User")

      t.timestamps

      t.index(:email, unique: true)
    end
  end
end
