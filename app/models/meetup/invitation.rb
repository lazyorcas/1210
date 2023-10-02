# frozen_string_literal: true

class Meetup::Invitation < Invitation
  default_scope { where(inviter_type: "Meetup", invitee_type: "User") }
end
