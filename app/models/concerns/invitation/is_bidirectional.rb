# frozen_string_literal: true

module Invitation::IsBidirectional
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    class << self
      def bidirectional_find_by(inviter:, invitee:)
        find_by(inviter: inviter, invitee: invitee) ||
          find_by(inviter: invitee, invitee: inviter)
      end
    end

    validate :inviter_and_invitee_are_different
  end

  def inviter_and_invitee_are_different
    return if inviter_id != invitee_id

    errors.add(:invitee, "can't be the same as inviter")
  end
end
