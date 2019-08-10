module Queries
  class Base
    def self.build(params, current_user, query_builder_klass = Queries::Builder)
      new(params, current_user, query_builder_klass.new)
    end

    def initialize(params, current_user, query_builder)
      @params = params
      @current_user = current_user
      @query_builder = query_builder
    end

    def search(pagination_number)
      class_name.search(query).page(pagination_number)
    end

    private

    attr_reader :params, :current_user, :query_builder

    def class_name
      self.class.name.demodulize.constantize
    end

    def query
      query_builder
        .query(bool: { must: must_params, must_not: must_not_params })
        .sort(sort_params)
        .filter(filter_params)
        .to_s
    end

    def must_params
      []
    end

    def must_not_params
      []
    end

    def sort_params
      []
    end

    def filter_params
      {}
    end
  end
end
