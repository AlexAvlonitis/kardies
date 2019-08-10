module Services
  class Users
    def initialize(current_user, page)
      @current_user = current_user
      @page = page
    end

    def all
      return get_all_indexed_users if search_present?

      get_all_users
    end

    private

    attr_reader :current_user, :page

    def search_present?
      current_user.search_criteria.present?
    end

    def get_all_users
      ::User.get_all.except_user(current_user).confirmed.page(page)
    end

    def get_all_indexed_users
      user_query.search(page).records
    end

    def user_query
      @user_query ||= Queries::User.build(last_search, current_user)
    end

    def last_search
      current_user.search_criteria.last
    end
  end
end
