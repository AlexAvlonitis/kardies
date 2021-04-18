module Api
  module V1
    class NewsController < ApiController
      def index
        news = ::New.all.page(params[:page])

        render json: news, status: :ok
      end

      private

      def news_params
        params.permit(:page)
      end
    end
  end
end
