module News
  module Users
    class CreatedJob < ApplicationJob
      include Rails.application.routes.url_helpers
      queue_as :default

      def perform(user)
        ::News::Users::Created.create(
          meta: {
            username: user.username,
            profile_picture: profile_picture(user)
          }.to_json
        )
      end

      private

      def profile_picture(user)
        user_decorator(user).profile_picture_thumb
      end

      def user_decorator(user)
        @user_decorator ||= UserDecorator.new(user)
      end
    end
  end
end
