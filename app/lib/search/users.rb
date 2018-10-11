module Search
  class Users < Base
    def execute
      UsersIndex::User
        .query(bool: { must: final_query })
        .filter(range: age_range)
        .filter(bool: must_not_be_current_user)
        .confirmed
        .order(created: :desc)
    end

    private

    def final_query
      [state, gender, is_signed_in]
    end

    def state
      query.state.blank? ? {} : { term: { state: query.state } }
    end

    def gender
      query.gender.blank? ? {} : { term: { gender: query.gender } }
    end

    def is_signed_in
      query.is_signed_in.blank? ? {} : { term: { is_signed_in: query.is_signed_in } }
    end

    def age_range
      { age: { gte: query.age_from, lte: query.age_to } }
    end

    def must_not_be_current_user
      { must_not: [{ term: { username: current_user.username } }] }
    end
  end
end
