module Users
  class GetAllUsersService
    def self.call(current_user, page, elastic_query_klass = Elastic::UserQuery)
      elastic_query = elastic_query(elastic_query_klass, current_user)
      new(current_user, page, elastic_query).call
    end

    def self.elastic_query(elastic_query_klass, current_user)
      return if current_user.search_criterium.blank?

      elastic_query_klass.call(
        params: current_user.search_criterium,
        current_user: current_user
      )
    end

    def initialize(current_user, page, elastic_query)
      @current_user = current_user
      @elastic_query = elastic_query
      @page = page
    end

    def call
      return elastic_users if elastic_query

      all_db_users
    end

    private

    attr_reader :current_user, :page, :elastic_query

    def all_db_users
      ::User.get_all.except_user(current_user).confirmed.page(page)
    end

    def elastic_users
      ::User.search(elastic_query).page(page).records.confirmed.compact
    end
  end
end
