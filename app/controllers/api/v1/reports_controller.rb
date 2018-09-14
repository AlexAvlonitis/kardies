module Api
  module V1
    class ReportsController < ApiController
      def create
        reportee = ::User.find_by(username: params[:username])
        unless reportee
          render json: { errors: 'Κάτι πήγε στραβά' }, status: :unprocessable_entity
          return
        end

        report = reportee.reports.new(report_params)
        if report.save
          render json: report, status: :ok
        else
          render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def report_params
        params.permit(:reason, :description)
              .merge(reporter_id: current_user.id)
      end
    end
  end
end
