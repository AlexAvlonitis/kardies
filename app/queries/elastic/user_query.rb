module Elastic
  class UserQuery
    def initialize(params, current_user, query_builder = BuilderQuery.new)
      @params = params
      @current_user = current_user
      @query_builder = query_builder
    end

    def search(pagination_number)
      ::User.search(query).page(pagination_number)
    end

    private

    attr_reader :params, :current_user, :query_builder

    def query
      query_builder
        .add_must_terms(must_terms)
        .add_must_not_terms(must_not_terms)
        .add_sort(sort_params)
        .add_range_filter(range_params)
        .query
    end

    def must_terms
      [
        { field: 'user_detail.state', value: params.state },
        { field: 'user_detail.gender', value: params.gender },
        { field: 'is_signed_in', value: params.is_signed_in }
      ]
    end

    def must_not_terms
      [{ field: 'username', value: current_user.username }]
    end

    def range_params
      { field: 'user_detail.age', gte: params.age_from, lte: params.age_to }
    end

    def sort_params
      [{ field: 'created_at', value: :desc }]
    end
  end
end
