module Api
  module V1
    class SearchCriteriaController < ApiController
      def create
        search_criteria = current_user.search_criteria.build(search_criteria_params)
        search_criteria = SearchCriterium.normalize_params(search_criteria)
        if search_criteria.save
         render json: 'saved', status: :ok
        else
          render json: search_criteria.errors, status: :unprocessable_entity
        end
      end

      private

      def search_criteria_params
        params.permit(allowed_params)
      end

      def allowed_params
        %i[state city gender age_from age_to is_signed_in]
      end
    end
  end
end
