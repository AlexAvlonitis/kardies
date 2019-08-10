require 'rails_helper'

describe Queries::User do
  let(:subject) do
    described_class.new(search_criteria, current_user, query_builder)
  end

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:query_builder) { instance_double(Queries::Builder) }

  let(:search_criteria) do
    FactoryBot.build_stubbed(:search_criterium, user: current_user)
  end

  let(:expected_query) do
    {
      query: query.merge(filter),
      sort: sort
    }
  end
  let(:query) do
    {
      bool: {
        must: [
          { term: { "user_detail.state" => search_criteria.state } },
          { term: { "user_detail.gender" => search_criteria.gender } },
          { term: { is_signed_in: search_criteria.is_signed_in } }
        ],
        must_not: [
          { term: { username: current_user.username } }
        ]
      }
    }
  end
  let(:filter) do
    {
      range: {
        "user_detail.age" => {
          gte: search_criteria.age_from,
          lte: search_criteria.age_to
        }
      }
    }
  end
  let(:sort) { [{ created_at: :desc }] }
  let(:results_per_page) { 20 }
  let(:query_results) { double(:result) }

  before do
    allow(query_builder).to receive(:query).with(query).and_return(query_builder)
    allow(query_builder).to receive(:filter).with(filter).and_return(query_builder)
    allow(query_builder).to receive(:sort).with(sort).and_return(query_builder)
    allow(query_builder).to receive(:to_s) { expected_query }
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
