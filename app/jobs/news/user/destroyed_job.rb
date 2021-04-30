module News
  module User
    class DestroyedJob < ApplicationJob
      queue_as :default

      def perform(user)
        ::News::User::Destroyed.create(
          meta: {
            username: user.username
          }.to_json
        )
      end
    end
  end
end
