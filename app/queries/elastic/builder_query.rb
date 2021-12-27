module Elastic
  class BuilderQuery
    attr_reader :query

    def initialize
      @query = { query: { bool: {} } }
    end

    def add_must_terms(terms)
      query[:query][:bool][:must] = build_terms(terms)
      self
    end

    def add_must_not_terms(terms)
      query[:query][:bool][:must_not] = build_terms(terms)
      self
    end

    def add_sort(params)
      query[:sort] = build_sorts(params)
      self
    end

    def add_range_filter(params)
      query[:query][:bool][:filter] = build_range(params)
      self
    end

    private

    def build_terms(terms)
      terms.map do |term|
        build_term(term[:field], term[:value]) if term[:value].present?
      end.compact
    end

    def build_term(field, value)
      { term: { field => value } }
    end

    def build_sorts(sort_params)
      sort_params.map { |sort| build_sort(sort[:field], sort[:value]) }
    end

    def build_sort(field, value)
      { field => value }
    end

    def build_range(params)
      {
        range: {
          params[:field] => {
            gte: params[:gte],
            lte: params[:lte]
          }
        }
      }
    end
  end
end
