# frozen_string_literal: true

class CurrentUserController < SocialNetworkController
  layout :resolve_layout

  def index
    @pending_user_invitations = current_user.received_invitations.pending.includes(:inviter)
  end

  def friends
    ahoy.track("visited_friends")
    load_friends
    sort_friends
  end

  def update
    if current_user.update(current_user_params)
      if current_user_params[:city].present?
        redirect_to(root_path)
      else
        redirect_to(current_user_path)
      end
    end
  end

  private

  def resolve_layout
    case action_name
    when "index"
      "main_tab"
    when "friends"
      "side_tab"
    else
      false
    end
  end

  def load_friends
    @friends = current_user.friends(params[:last_met])
  end

  def sort_friends
    @friends = @friends.sort_by(&:name)
  end

  def current_user_params
    params.require(:user).permit(:avatar, :city)
  end
end
