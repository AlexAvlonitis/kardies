module Api
  module V1
    class UsersController < ApiController
      def index
        users = search_present? ? get_all_indexed_users : get_all_users

        users.compact!
        render json: users, status: :ok
      end

      private

      def search_present?
        current_user.search_criteria.present?
      end

      def get_all_users
        User.get_all.except_user(current_user).confirmed.page(params[:page])
      end

      def get_all_indexed_users
        User.search(last_search, current_user).page(params[:page]).objects
      end

      def last_search
        current_user.search_criteria.last
      end
    end
  end
end
