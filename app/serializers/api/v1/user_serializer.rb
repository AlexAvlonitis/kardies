require 'action_view'

module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      include ActionView::Helpers::DateHelper

      has_one  :user_detail

      attributes :username, :profile_picture_medium, :profile_picture_thumb

      delegate :profile_picture_medium, :profile_picture_thumb, to: :user_presenter

      private

      def voted_by
        object.votes.find_by(votable_id: scope.id)
      end

      def user_presenter
        @user_presenter ||= UserPresenter.new(object)
      end
    end
  end
end
