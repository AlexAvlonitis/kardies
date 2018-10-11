module Search
  class Base
    def initialize(query, current_user)
      @query = query
      @current_user = current_user
    end

    private

    attr_reader :query, :current_user
  end
end
