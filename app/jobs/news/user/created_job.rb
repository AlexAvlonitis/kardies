module News
  module User
    class CreatedJob < ApplicationJob
      queue_as :default

      def perform(user)
        ::News::User::Created.create(
          meta: {
            username: user.username,
            profile_picture: profile_picture(user)
          }.to_json
        )
      end

      private

      def profile_picture(user)
        user_presenter(user).profile_picture_thumb
      end

      def user_presenter(user)
        @user_presenter ||= UserPresenter.new(user)
      end
    end
  end
end
