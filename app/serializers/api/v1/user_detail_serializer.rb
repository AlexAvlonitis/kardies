module Api
  module V1
    class UserDetailSerializer < ActiveModel::Serializer
      attributes :state, :age, :gender

      def state
        GC.get_state_name(object.state)
      end
    end
  end
end
