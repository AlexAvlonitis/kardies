class Search

  def initialize(query)
    @query = query
  end

  def call
    users = users_index.query(bool: { must: final_query })
                       .filter(range: age_range)
                       .order(created: :desc)
    users.objects
  end

  private

  attr_reader :query

  def users_index
    UsersIndex::User
  end

  def final_query
    query_array = []
    query_array << state
    query_array << gender
    query_array << is_signed_in
    query_array.delete_if(&:empty?)
    query_array
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
    { age: { gt: query.age_from, lt: query.age_to } }
  end
end
