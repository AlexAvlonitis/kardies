module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      has_one :user_detail
      has_one :about

      attributes :username,
                 :profile_picture,
                 :profile_picture_medium,
                 :like,
                 :email

      def like
        current_user.voted_for? object if current_user
      end

      def email
        current_user === object ? object.email : nil
      end
    end
  end
end
