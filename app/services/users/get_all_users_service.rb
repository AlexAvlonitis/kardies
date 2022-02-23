module Users
  class GetAllUsersService < BaseService
    def initialize(params)
      @current_user = params[:current_user]
      @page         = params[:page]
    end

    def call
      return elastic_users if search_criterium?

      db_users
    end

    private

    attr_reader :current_user, :page

    def db_users
      Users::GetAllUsersQuery
        .call
        .except_user(current_user)
        .confirmed
        .page(page)
    end

    def elastic_users
      ::User
        .search(elastic_users_query)
        .page(page)
        .records
        .confirmed
        .compact
    end

    def search_criterium?
      current_user&.search_criterium&.present?
    end

    def elastic_users_query
      Elastic::UserQuery.call(
        params: current_user.search_criterium,
        current_user: current_user
      )
    end
  end
end
