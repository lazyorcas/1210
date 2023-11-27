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
      @default_modal_src = new_user_invitation_path
    elsif current_user.city.nil?
      @default_modal_src = current_user_edit_city_path
    elsif !has_visited_current_user_availabilities_event_today && Time.zone.now >= "07:00"
      @default_modal_src = current_user_availabilities_path
    end
  end

  def has_visited_current_user_availabilities_event_today
    Ahoy::Event
      .where(user: current_user, name: "visited_current_user_availabilities")
      .order(time: :desc)
      .first&.time&.to_date == Time.zone.today
  end

  def associate_visit_with_current_user
    ahoy.authenticate(current_user)
  end

  def set_current_user_timezone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
