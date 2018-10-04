module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: :show

      def index
        render json: all_users, status: :ok
      end

      def show
        authorize @user

        unless profile_pic_exists?
          return block_and_render('You need a profile pic')
        end

        render json: @user, status: :ok
      end

      private

      def set_user
        @user = User.find_by(username: params[:username])
        unless @user
          return render json: {
              errors: "O χρήστης #{params[:username]} δεν υπάρχει"
            }, status: :not_found
        end
      end

      def profile_pic_exists?
        return true if @user == current_user
        current_user.profile_picture_exists?
      end

      def all_users
        @all_users ||= Services::Users.new(current_user, params[:page]).all
      end
    end
  end
end
