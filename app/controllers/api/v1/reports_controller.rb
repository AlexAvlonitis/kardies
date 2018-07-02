module Api
  module V1
    class ReportsController < ApiController
      def create
        reportee = User.find_by(username: params[:report][:username])
        report = reportee.reports.new(report_params)

        if report.save
          flash[:success] = t '.sent'
          redirect_to user_path(reportee)
        else
          flash[:alert] = t '.not_sent'
          render 'show'
        end
      end

      private

      def report_params
        params.require(:report)
              .permit(:reason, :description)
              .merge(reporter_id: current_user.id)
      end
    end
  end
end
