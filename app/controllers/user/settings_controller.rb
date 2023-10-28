# frozen_string_literal: true

class User::SettingsController < ApplicationController
  layout "user/settings"

  before_action :require_user!
end
