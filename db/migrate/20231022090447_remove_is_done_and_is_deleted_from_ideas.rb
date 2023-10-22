# frozen_string_literal: true

class RemoveIsDoneAndIsDeletedFromIdeas < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column(:ideas, :is_done) }
    safety_assured { remove_column(:ideas, :is_deleted) }
  end
end
