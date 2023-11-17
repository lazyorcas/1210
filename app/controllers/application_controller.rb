# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  helper_method :current_user

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def require_user!
    return if current_user

    save_passwordless_redirect_location!(User)
    redirect_to(root_path)
  end

  def require_admin!
    unless current_user&.admin?
      head(:forbidden)
    end
  end

  def require_mobile!
    unless browser.device.mobile?
      redirect_to(download_path)
    end
  end
end
