class SearchCriteriaController < ApplicationController

  def create
    search_criteria = current_user.search_criteria.build(search_criteria_params)
    search_criteria.save
    redirect_to users_path
  end

  private

  def search_criteria_params
    params.permit(allowed_params)
  end

  def allowed_params
    [:state, :city, :gender, :age_from, :age_to, :is_signed_in]
  end

end
