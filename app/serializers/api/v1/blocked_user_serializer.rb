module Api
  module V1
    class BlockedUserSerializer < ActiveModel::Serializer
      attributes :user

      def user
        blocked_user = User.find(object.blocked_user_id)
        UserSerializer.new(blocked_user, {scope: current_user})
      end
    end
  end
end
