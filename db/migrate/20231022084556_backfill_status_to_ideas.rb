# frozen_string_literal: true

class BackfillStatusToIdeas < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    Idea.unscoped.where(is_deleted: true).in_batches do |ideas|
      ideas.update_all(status: -1)
      sleep(0.01) # throttle
    end

    Idea.unscoped.where(is_done: true).in_batches do |ideas|
      ideas.update_all(status: 1)
      sleep(0.01) # throttle
    end

    Idea.unscoped.where(is_done: false, is_deleted: false).in_batches do |ideas|
      ideas.update_all(status: 0)
      sleep(0.01) # throttle
    end
  end
end
