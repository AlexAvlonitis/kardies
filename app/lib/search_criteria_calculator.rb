class SearchCriteriaCalculator
  def initialize(user)
    @user = user
  end

  def state
    if @user.search_criteria.present? && @user.search_criteria.last.state
      @user.search_criteria.last.state
    else
      ''
    end
  end

  def gender
    if @user.search_criteria.present? && @user.search_criteria.last.gender
      @user.search_criteria.last.gender
    else
      ''
    end
  end

  def age_from
    if @user.search_criteria.present? && @user.search_criteria.last.age_from
      @user.search_criteria.last.age_from
    else
      18
    end
  end

  def age_to
    if @user.search_criteria.present? && @user.search_criteria.last.age_to
      @user.search_criteria.last.age_to
    else
      99
    end
  end

  def signed_in?
    if @user.search_criteria.present? && @user.search_criteria.last.is_signed_in
      @user.search_criteria.last.is_signed_in
    else
      'false'
    end
  end

  def jsonfy
    all_values = {}
    all_values[:state] = state
    all_values[:gender] = gender
    all_values[:age_from] = age_from
    all_values[:age_to] = age_to
    all_values[:is_signed_in] = signed_in?
    all_values
  end
end
