# frozen_string_literal: true

class Thing::Availability::Invitation < Invitation
  include Invitation::IsComplete

  default_scope { where(inviter_type: "Thing", invitee_type: "Availability") }

  def thing
    inviter
  end

  def availability
    invitee
  end
end
