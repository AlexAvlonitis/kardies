class Admin::ReportsController < Admin::ApplicationController

  def index
    @reports = Report.all
  end
end