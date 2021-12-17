# frozen_string_literal: true

module Errors
  module Memberships
    class DenyError < StandardError
      def message
        'Έχετε συνδρομή ήδη.'
      end
    end
  end
end
