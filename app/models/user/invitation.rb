# frozen_string_literal: true

class User::Invitation < Invitation
  include Invitation::IsBidirectional

  default_scope { where(inviter_type: "User", invitee_type: "User") }
end
