module Api
  module V1
    class GoldenHeartController < ApiController
      before_action :set_user, only: :create

      def create
        if current_user.membership && !current_user.membership&.expired?
          if current_user.golden_hearts.find_by(heartable: @user)
            return render json: { errors: 'Έχετε ήδη στείλει χρυσή καρδιά' }, status: :forbidden
          else
            return send_golden_like
          end
        end

        render json: { errors: 'Δεν είστε χρυσό μέλος' }, status: :forbidden
      end


      private

      def send_golden_like
        GoldenHeart.create(hearter: current_user, heartable: @user)
        Notifications::Hearts.new(@user, GoldenHeartMailer).execute

        render json: { message: "Χρυσή καρδιά εστάλει!" }, status: :ok
      end

      def set_user
        @user = ::User.find_by!(username: params[:username])
        authorize(@user)
      end
    end
  end
end
