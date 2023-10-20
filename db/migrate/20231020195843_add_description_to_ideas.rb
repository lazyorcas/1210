# frozen_string_literal: true

class AddDescriptionToIdeas < ActiveRecord::Migration[7.0]
  def change
    add_column(:ideas, :description, :text)
  end
end
