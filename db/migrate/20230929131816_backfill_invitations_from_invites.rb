# frozen_string_literal: true

class BackfillInvitationsFromInvites < ActiveRecord::Migration[7.0]
  def up
    Invite.find_each do |invite|
      Invitation.create(
        inviter_type: "User",
        inviter_id: invite.inviter_id,
        invitee_type: "User",
        invitee_id: invite.invitee_id,
        is_accepted: invite.is_accepted,
        created_at: invite.created_at,
        updated_at: invite.updated_at,
      )

      sleep(0.01) # throttle
    end
  end
end
