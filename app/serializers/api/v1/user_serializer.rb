require 'action_view'

module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      include ActionView::Helpers::DateHelper

      has_one :user_detail
      has_one :about

      attributes :username,
                 :profile_picture,
                 :profile_picture_medium,
                 :like,
                 :like_date,
                 :email

      def like
        current_user.voted_for? object if current_user
      end

      def like_date
        like_time = find_user_like
        distance_of_time_in_words(like_time.updated_at, to_time) if like_time
      end

      def email
        current_user === object ? object.email : nil
      end

      private

      def to_time
        Time.now
      end

      def find_user_like
        object.votes.find_by(votable_id: current_user.id)
      end
    end
  end
end
