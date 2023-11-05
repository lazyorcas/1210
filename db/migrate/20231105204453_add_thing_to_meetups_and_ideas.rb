# frozen_string_literal: true

class AddThingToMeetupsAndIdeas < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference(:meetups, :thing, index: { algorithm: :concurrently })
    add_reference(:ideas, :thing, index: { algorithm: :concurrently })
  end
end
