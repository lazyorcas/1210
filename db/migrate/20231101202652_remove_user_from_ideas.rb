# frozen_string_literal: true

class RemoveUserFromIdeas < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column(:ideas, :user_id) }
  end
end
