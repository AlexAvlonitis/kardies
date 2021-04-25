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
        rails_representation_url(user.profile_picture_thumb)
      rescue StandardError
        nil
      end
    end
  end
end
