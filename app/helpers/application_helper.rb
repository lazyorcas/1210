# frozen_string_literal: true

module ApplicationHelper
  def search_param_toggled_current_path(key)
    current_params = params.permit(key)
    current_params[key] = current_params[key].present? ? nil : "true"
    url_for(**current_params, only_path: true)
  end
end
