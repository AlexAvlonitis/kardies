# frozen_string_literal: true

module Errors
  module Memberships
    class UndefinedError < StandardError
      def message
        'Δεν έγινε η ακύρωση, παρακαλούμε επικοινωνήστε με την τεχνική υποστήριξη.'
      end
    end
  end
end
