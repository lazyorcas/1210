# frozen_string_literal: true

class BackfillMeetupAttendancessIsCancelled < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    MeetupAttendance.unscoped.in_batches do |relation|
      relation.update_all(is_cancelled: false)
      sleep(0.01) # throttle
    end
  end
end
