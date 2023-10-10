# frozen_string_literal: true

class BackfillIdeasIsDeleted < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    Idea.unscoped.in_batches do |relation|
      relation.update_all(is_deleted: false)
      sleep(0.01) # throttle
    end
  end
end
