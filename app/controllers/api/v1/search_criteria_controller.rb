module Api
  module V1
    class SearchCriteriaController < ApiController
      before_action :set_search_criterium, only: :update

      def update
        if @search_criterium.update(search_criterium_params)
          render json: users, status: :ok
        else
          render json: @search_criterium.errors, status: :unprocessable_entity
        end
      end

      private

      def users
        user_query.search(params[:page]).records.confirmed
      end

      def user_query
        @user_query ||= Elastic::UserQuery.new(@search_criterium, current_user)
      end

      def search_criterium_params
        params.require(:search_criterium).permit(allowed_params)
      end

      def allowed_params
        %i[state gender age_from age_to is_signed_in]
      end

      def set_search_criterium
        @search_criterium = current_user.search_criterium ||
          current_user.build_search_criterium
      end
    end
  end
end
