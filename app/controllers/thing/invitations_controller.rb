# frozen_string_literal: true

class Thing::InvitationsController < ApplicationController
  before_action :require_user!

  def index
    load_thing
    abstract_thing
    load_current_user_thing_invitation

    @thing_invitation ||= Thing::Invitation.new(inviter: @thing)
  end

  def create
    load_thing
    abstract_thing

    @thing_invitation = Thing::Invitation.new(thing_invitation_params)
    @thing_invitation.inviter = @thing
    @thing_invitation.invitee = current_user

    if @thing_invitation.save
      turbo_stream
    end
  end

  def update
    load_thing
    abstract_thing
    load_current_user_thing_invitation

    if @thing_invitation.update(thing_invitation_params)
      turbo_stream
    end
  end

  private

  def load_thing
    @thing = Thing.find(params[:thing_id])
  end

  def abstract_thing
    @thing = @thing.becomes(Thing)
  end

  def load_current_user_thing_invitation
    @thing_invitation = Thing::Invitation.find_by(inviter: @thing, invitee: current_user)
  end

  def thing_invitation_params
    params.require(:thing_invitation).permit(:is_accepted)
  end
end
