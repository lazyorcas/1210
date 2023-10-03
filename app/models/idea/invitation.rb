# frozen_string_literal: true

class Idea::Invitation < Invitation
  default_scope { where(inviter_type: "Idea", invitee_type: "User") }
end
