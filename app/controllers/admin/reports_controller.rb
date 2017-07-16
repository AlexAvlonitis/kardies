module Admin
  class ReportsController < Admin::ApplicationController
    def index
      @reports = Report.all
    end
  end
end
