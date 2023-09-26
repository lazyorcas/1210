# frozen_string_literal: true

class InvitesController < ApplicationController
  before_action :require_user!, only: [:create, :accept]

  def create
    new_params = params.require(:invite).permit(:invitee_id)

    @invite = Invite.new(new_params)
    @invite.inviter_id = current_user.id

    if @invite.save
      redirect_to(friends_path)
    end
  end

  def accept
    load_received_invite

    if @invite.update(is_accepted: true)
      redirect_to(friends_path)
    end
  end

  private

  def load_received_invite
    @invite = Invite.find_by(id: params[:id], invitee_id: current_user.id)
  end
end
