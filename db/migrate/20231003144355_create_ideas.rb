# frozen_string_literal: true

class CreateIdeas < ActiveRecord::Migration[7.0]
  def change
    create_table(:ideas) do |t|
      t.string(:title)
      t.boolean(:is_done, default: false)

      t.belongs_to(:user)

      t.timestamps

      t.index(:is_done)
    end
  end
end
