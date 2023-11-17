# frozen_string_literal: true

class SocialNetworkController < ApplicationController
  before_action :require_mobile!
  before_action :require_user!
  before_action :load_default_modal_src
  before_action :associate_visit_with_current_user
  around_action :set_current_user_timezone

  private

  def load_default_modal_src
    if current_user.friends.count == 0
      @default_modal_src = user_path(current_user)
    end
  end

  def associate_visit_with_current_user
    ahoy.authenticate(current_user)
  end

  def set_current_user_timezone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
