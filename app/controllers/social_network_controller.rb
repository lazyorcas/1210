# frozen_string_literal: true

class SocialNetworkController < ApplicationController
  before_action :require_user!
  before_action :associate_visit_with_current_user
  around_action :set_current_user_timezone

  private

  def associate_visit_with_current_user
    ahoy.authenticate(current_user)
  end

  def set_current_user_timezone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
