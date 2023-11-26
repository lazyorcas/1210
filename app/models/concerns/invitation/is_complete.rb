# frozen_string_literal: true

module Invitation::IsComplete
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    validates_presence_of :invitee
  end
end
