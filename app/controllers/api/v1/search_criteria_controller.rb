module Api
  module V1
    class SearchCriteriaController < ApiController
      def create
        if search_criteria.save
          render json: users, status: :ok
        else
          render json: search_criteria.errors, status: :unprocessable_entity
        end
      end

      private

      def users
        user_query.search(params[:page]).records.confirmed
      end

      def user_query
        @user_query ||= Elastic::UserQuery.new(search_criteria, current_user)
      end

      def search_criteria
        @search_criteria ||=
          current_user.search_criteria.new(search_criteria_params)
      end

      def search_criteria_params
        params.permit(allowed_params)
      end

      def allowed_params
        %i[state gender age_from age_to is_signed_in]
      end
    end
  end
end
