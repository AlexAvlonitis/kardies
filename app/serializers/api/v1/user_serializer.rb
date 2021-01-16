require 'action_view'

module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      include ActionView::Helpers::DateHelper
      include Rails.application.routes.url_helpers

      has_one :user_detail
      has_one :about
      has_one :email_preference
      has_one :membership
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
        return unless object.profile_picture

        rails_blob_url(object.profile_picture)
      end

      def profile_picture_medium
        return unless object.profile_picture

        rails_representation_url(object.profile_picture_medium)
      end

      def profile_picture_thumb
        return unless object.profile_picture

        rails_representation_url(object.profile_picture_thumb)
      end

      def like
        scope.voted_for?(object) if scope
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
