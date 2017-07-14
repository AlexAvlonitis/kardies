class ReportsController < ApplicationController
  def create
    reportee = User.find_by(username: params[:report][:username])
    report = reportee.reports.new(report_params)

    if report.save
      flash[:success] = 'Report has been sent'
      redirect_to users_path
    else
      flash[:alert] = 'Report has not been sent'
      render 'show'
    end
  end

  def show
    @report = Report.new
  end

  private

  def report_params
    params.require(:report).permit(:reason, :description)
          .merge(reporter_id: current_user.id)
  end
end
