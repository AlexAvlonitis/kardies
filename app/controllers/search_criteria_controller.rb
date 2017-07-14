class SearchCriteriaController < ApplicationController
  def create
    search_criteria = current_user.search_criteria.build(search_criteria_params)
    search_criteria = SearchCriterium.normalize_params(search_criteria)
    if search_criteria.save
      redirect_to users_path
    else
      flash[:alert] = 'Ops something went wrong, try again'
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
