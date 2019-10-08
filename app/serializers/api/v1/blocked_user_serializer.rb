module Api
  module V1
    class BlockedUserSerializer < ActiveModel::Serializer
      attributes :user

      def user
        blocked_user = User.find_by(id: object.blocked_user_id)
        return [] unless blocked_user

        UserSerializer.new(blocked_user, scope: current_user)
      end
    end
  end
end
