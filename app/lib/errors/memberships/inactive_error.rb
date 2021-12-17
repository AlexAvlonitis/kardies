# frozen_string_literal: true

module Errors
  module Memberships
    class InactiveError < StandardError
      def message
        'Δεν έχετε ενεργή συνδρομή.'
      end
    end
  end
end
