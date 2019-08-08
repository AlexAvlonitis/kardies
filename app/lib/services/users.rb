module Services
  class Users
    def initialize(current_user, page)
      @current_user = current_user
      @page = page
    end

    def all
      search_present? ? get_all_indexed_users : get_all_users
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
      Queries::User.new(last_search, current_user)
        .search(page)
        .records
    end

    def last_search
      current_user.search_criteria.last
    end
  end
end
