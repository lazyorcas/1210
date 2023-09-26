# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  helper_method :current_user

  around_action :set_current_user_timezone, if: :current_user

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def require_user!
    return if current_user

    save_passwordless_redirect_location!(User)
    redirect_to(root_path)
  end

  def set_current_user_timezone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
