module Api
  module V1
    module Admin
      class ReportsController < AdminController
        def index
          @reports = Report.all
        end
      end
    end
  end
end
