# frozen_string_literal: true

module Invitation::IsBidirectional
  extend ActiveSupport::Concern

  included do
    class << self
      def bidirectional_find_by(inviter:, invitee:)
        find_by(inviter: inviter, invitee: invitee) ||
          find_by(inviter: invitee, invitee: inviter)
      end
    end
  end
end
