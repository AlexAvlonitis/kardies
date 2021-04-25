module News
  module Users
    class DestroyedJob < ApplicationJob
      queue_as :default

      def perform(user)
        News::Users::Destroyed.create(
          meta: {
            username: user.username
          }.to_json
        )
      end
    end
  end
end
