module Queries
  class Base
    def initialize(params, current_user)
      @params = params
      @current_user = current_user
    end

    def search(pagination_number)
      class_name.search(query).page(pagination_number)
    end

    private

    attr_reader :params, :current_user

    def class_name
      self.class.name.demodulize.constantize
    end

    def query
      query_builder
        .query(bool: { must: musts, must_not: must_nots })
        .sort(sorts)
        .filter(filters)
        .to_s
    end

    def query_builder
      @query_builder ||= Queries::Builder.new
    end
  end
end
