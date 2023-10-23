# frozen_string_literal: true

class Idea::Option::Invitation < Invitation
  default_scope { where(inviter_type: "Idea::Option", invitee_type: "User") }
end
