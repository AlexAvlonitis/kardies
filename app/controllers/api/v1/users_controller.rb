module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: :show

      def index
        users = search_present? ? get_all_indexed_users : get_all_users

        render json: users, status: :ok
      end

      def show
        if ::UserBlockedCheck.call(current_user, @user)
          return block_and_render(t('users.show.blocked_user'))
        end

        return block_and_render('You need a profile pic') unless profile_pic_exists?
        render json: @user, status: :ok
      end

      private

      def set_user
        @user = ::User.find_by(username: params[:username])
        unless @user
          return render json: {
              errors: "O χρήστης #{params[:username]} δεν υπάρχει"
            }, status: :not_found
        end
      end

      def search_present?
        current_user.search_criteria.present?
      end

      def get_all_users
        ::User.get_all.except_user(current_user).confirmed.page(params[:page])
      end

      def get_all_indexed_users
        ::User.search(last_search, current_user).page(params[:page]).objects
      end

      def last_search
        current_user.search_criteria.last
      end

      def profile_pic_exists?
        return true if @user == current_user
        current_user.profile_picture_exists?
      end
    end
  end
end
