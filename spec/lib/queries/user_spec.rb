require 'rails_helper'

describe Queries::User do
  let(:subject) { described_class.new(search_criteria, current_user) }

  let(:current_user) { FactoryBot.build_stubbed(:user) }

  let(:search_criteria) do
    FactoryBot.build_stubbed(:search_criterium, user: current_user)
  end

  let(:expected_query) do
    {
      query: {
        bool: {
          must: [
            { term: { "user_detail.state" => search_criteria.state } },
            { term: { "user_detail.gender" => search_criteria.gender } },
            { term: { is_signed_in: search_criteria.is_signed_in } }
          ],
          must_not: [
            { term: { username: current_user.username } }
          ],
          filter: {
            range: {
              "user_detail.age" => { gte: search_criteria.age_from, lte: search_criteria.age_to }
            }
          }
        }
      },
      sort: [
        { created_at: :desc }
      ]
    }
  end
  let(:results_per_page) { 20 }
  let(:query_results) { double(:result) }

  before do
    allow(query_results).to receive(:page) { nil }
  end

  describe '#search' do
    it 'creates a correct query' do
      expect(::User)
        .to receive(:search)
        .with(expected_query)
        .and_return(query_results)

      subject.search(results_per_page)
    end
  end
end
