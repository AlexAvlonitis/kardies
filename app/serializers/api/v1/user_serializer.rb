module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      has_one :user_detail
      has_one :about

      attributes :username, :profile_picture, :profile_picture_medium, :like

      def like
        current_user.voted_for? object if current_user
      end
    end
  end
end
