# frozen_string_literal: true

module Thing::Availability::InvitationsHelper
  def thing_availability_invitation_dom_id(invitation)
    "thing_#{invitation.thing.id}_availability_#{invitation.availability.id}_invitation"
  end
end
