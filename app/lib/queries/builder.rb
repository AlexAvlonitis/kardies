module Queries
  class Builder
    def initialize()
      @final_query = {}
    end

    def to_s
      @final_query
    end

    def sort(params = {})
      build_sort(params)
      self
    end

    def query(params = {})
      build_query(params)
      self
    end

    def filter(params = {})
      build_filter(params)
      self
    end

    private

    def build_sort(params)
      @final_query[:sort] = params
    end

    def build_query(params)
      @final_query[:query] = params
    end

    def build_filter(params)
      build_query(bool: nil) if @final_query.dig(:query, :bool).nil?

      @final_query[:query][:bool][:filter] = params
    end
  end
end
