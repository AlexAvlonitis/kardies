require 'action_view'

module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      include ActionView::Helpers::DateHelper

      has_one :user_detail
      has_one :about
      has_one :email_preference
      has_many :pictures, through: :gallery

      attributes :username,
                 :profile_picture,
                 :profile_picture_medium,
                 :profile_picture_thumb,
                 :like,
                 :like_date,
                 :email,
                 :is_signed_in

      def profile_picture
        object.profile_picture(:original)
      end

      def profile_picture_thumb
        object.profile_picture(:thumb)
      end

      def like
        scope.voted_for? object
      end

      def like_date
        voter = user_like
        return unless voter

        distance_of_time_in_words(voter.updated_at, to_time)
      end

      def email
        scope === object ? object.email : nil
      end

      private

      def to_time
        Time.now
      end

      def user_like
        object.votes.find_by(votable_id: scope.id)
      end
    end
  end
end
