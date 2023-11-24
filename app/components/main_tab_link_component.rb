# frozen_string_literal: true

class MainTabLinkComponent < ViewComponent::Base
  include ActionView::Helpers::UrlHelper
  include HeroiconHelper

  def initialize(path:, icon_name:, indicator_count: nil, show_indicator: false)
    super
    @path = path
    @icon_name = icon_name
    @indicator_count = indicator_count
    @show_indicator = show_indicator
  end
end
