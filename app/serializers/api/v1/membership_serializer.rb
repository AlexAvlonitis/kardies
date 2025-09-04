module Api
  module V1
    class MembershipSerializer < ActiveModel::Serializer
      attributes :active, :expiry_date, :expired, :amount, :interval, :interval_count

      def expired
        object.expired?
      end

      def expiry_date
        object.expiry_date.strftime("%d/%m/%Y") if object.expiry_date
      end
    end
  end
end
