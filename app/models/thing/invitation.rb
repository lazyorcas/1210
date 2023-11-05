# frozen_string_literal: true

class Thing::Invitation < Invitation
  default_scope { where(inviter_type: "Thing", invitee_type: "User") }

  validates_uniqueness_of :inviter_id, scope: :invitee_id
end
