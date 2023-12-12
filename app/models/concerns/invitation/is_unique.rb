# frozen_string_literal: true

module Invitation::IsUnique
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    validates_uniqueness_of :invitee_id, scope: [:inviter_id]
  end
end
