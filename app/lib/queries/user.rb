module Queries
  class User < Base
    private

    def sort_params
      [sort_by_latest]
    end

    def must_not_params
      [current_username]
    end

    def must_params
      [state, gender, is_signed_in].compact
    end

    def filter_params
      age_range
    end

    def state
      { term: { 'user_detail.state' => params.state } } if params.state.present?
    end

    def gender
      { term: { 'user_detail.gender' => params.gender } } if params.gender.present?
    end

    def is_signed_in
      { term: { is_signed_in: params.is_signed_in } } if params.is_signed_in.present?
    end

    def sort_by_latest
      { created_at: :desc }
    end

    def age_range
      {
        range: {
          'user_detail.age' => { gte: params.age_from, lte: params.age_to }
        }
      }
    end

    def current_username
      { term: { username: current_user.username } }
    end
  end
end
