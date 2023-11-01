# frozen_string_literal: true

class BackfillOrganizerToIdeas < ActiveRecord::Migration[7.0]
  def change
    Idea.unscoped.in_batches do |relation|
      relation.update_all("organizer_id = user_id")
      sleep(0.01) # throttle
    end
  end
end
