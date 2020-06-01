module Api
  module V1
    class MembershipSerializer < ActiveModel::Serializer
      attributes :active, :expiry_date, :expired

      def expired
        return unless object.subscription_id

        expiry_date_int = object.expiry_date || 0
        (Time.at(expiry_date_int) < Time.now) ? true : false
      end

      def expiry_date
        object.expiry_date.strftime("%d/%m/%Y") if object.expiry_date
      end
    end
  end
end
