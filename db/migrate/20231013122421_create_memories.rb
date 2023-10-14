# frozen_string_literal: true

class CreateMemories < ActiveRecord::Migration[7.0]
  def change
    create_table(:memories) do |t|
      t.belongs_to(:meetup)

      t.timestamps
    end
  end
end
