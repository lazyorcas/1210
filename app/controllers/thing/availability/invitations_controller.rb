# frozen_string_literal: true

class Thing::Availability::InvitationsController < SocialNetworkController
  def create
    load_thing
    abstract_thing
    load_availability

    @invitation = Thing::Availability::Invitation.new(thing_availability_invitation_params)
    @invitation.inviter = @thing
    @invitation.invitee = @availability

    if @invitation.save
      turbo_stream
    end
  end

  def update
    load_availability
    load_invitation

    if @invitation.update(thing_availability_invitation_params)
      turbo_stream
    end
  end

  private

  def load_thing
    @thing = thing_scope.find(params[:thing_id])
  end

  def abstract_thing
    @thing = @thing.becomes(Thing)
  end

  def load_availability
    @availability = availability_scope.find(params[:availability_id])
  end

  def load_invitation
    @invitation = @availability.thing_invitations.find(params[:id])
  end

  def thing_scope
    current_user.interests
  end

  def availability_scope
    current_user.availabilities
  end

  def thing_availability_invitation_params
    params.require(:thing_availability_invitation).permit(:is_accepted)
  end
end
