module Elastic
  class UserQuery
    def self.call(params)
      query_builder = QueryBuilder.new
      new(params.merge(query_builder: query_builder)).call
    end

    def initialize(params)
      @query_builder = params[:query_builder]
      @current_user  = params[:current_user]
      @params        = params[:params]
    end

    def call
      query_builder
        .add_must_terms(must_terms)
        .add_must_not_terms(must_not_terms)
        .add_sort(sort_params)
        .add_range_filter(range_params)
        .query
    end

    private

    attr_reader :params, :current_user, :query_builder

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
      [{ field: 'created_at', value: params.sort_by }]
    end
  end
end
