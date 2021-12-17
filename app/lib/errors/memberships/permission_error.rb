# frozen_string_literal: true

module Errors
  module Memberships
    class PermissionError < StandardError
      def message
        'Απαγόρευση εντολής'
      end
    end
  end
end
