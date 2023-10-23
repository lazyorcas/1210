# frozen_string_literal: true

class CreatePollableOptions < ActiveRecord::Migration[7.0]
  def change
    create_table(:pollable_options) do |t|
      t.string(:title)
      t.references(:pollable, polymorphic: true)

      t.timestamps
    end
  end
end
