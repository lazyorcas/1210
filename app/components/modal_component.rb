# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include HeroiconHelper

  renders_one :toolbar
  renders_one :body
  renders_one :footer

  def initialize(title: nil, close_disabled: false)
    super
    @title = title
    @close_disabled = close_disabled
  end
end
