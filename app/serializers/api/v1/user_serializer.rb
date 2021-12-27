require 'action_view'

module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      include ActionView::Helpers::DateHelper

      has_one  :user_detail
      has_one  :about
      has_one  :email_preference
      has_one  :membership
      has_many :pictures, through: :gallery

      attributes :username,
                 :profile_picture,
                 :profile_picture_medium,
                 :profile_picture_thumb,
                 :like,
                 :like_date,
                 :email,
                 :is_signed_in

      delegate :profile_picture,        to: :user_presenter
      delegate :profile_picture_medium, to: :user_presenter
      delegate :profile_picture_thumb,  to: :user_presenter

      def like
        scope.voted_for?(object) if scope
      end

      def like_date
        voter = voted_by
        return unless voter

        distance_of_time_in_words(voter.updated_at, time_now)
      end

      def email
        scope === object ? object.email : nil
      end

      private

      def time_now
        Time.now
      end

      def voted_by
        object.votes.find_by(votable_id: scope.id)
      end

      def user_presenter
        @user_presenter ||= UserPresenter.new(object)
      end
    end
  end
end
