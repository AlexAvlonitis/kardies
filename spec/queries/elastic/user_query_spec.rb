require 'rails_helper'

describe Elastic::UserQuery do
  let(:subject) do
    described_class.new(query_builder, params)
  end

  let(:params) { { params: search_criteria, current_user: current_user } }
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:query_builder) { instance_double(Elastic::QueryBuilder) }
  let(:search_criteria) do
    FactoryBot.build_stubbed(:search_criterium, user: current_user)
  end

  let(:expected_query) do
    {
      query: query,
      sort: [{ created_at: :desc }]
    }
  end
  let(:query) do
    {
      bool: {
        must: [
          { term: { 'user_detail.state' => search_criteria.state } },
          { term: { 'user_detail.gender' => search_criteria.gender } },
          { term: { is_signed_in: search_criteria.is_signed_in } }
        ],
        must_not: [
          { term: { username: current_user.username } }
        ],
        filter: filter
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
  let(:query_results) { double(:query_results) }
  let(:must_params) do
    [
      { field: 'user_detail.state', value: search_criteria.state },
      { field: 'user_detail.gender', value: search_criteria.gender },
      { field: 'is_signed_in', value: search_criteria.is_signed_in }
    ]
  end
  let(:must_not_params) do
    [{ field: 'username', value: current_user.username }]
  end
  let(:sort_params) { [{ field: 'created_at', value: :desc }] }
  let(:range_params) do
    {
      field: 'user_detail.age',
      gte: search_criteria.age_from,
      lte: search_criteria.age_to
    }
  end

  before do
    allow(query_builder).to receive(:add_must_terms) { query_builder }
    allow(query_builder).to receive(:add_must_not_terms) { query_builder }
    allow(query_builder).to receive(:add_range_filter) { query_builder }
    allow(query_builder).to receive(:add_sort) { query_builder }
    allow(query_builder).to receive(:query) { expected_query }
  end

  describe '#call' do
    it 'sends add_must_terms to query builder' do
      expect(query_builder)
        .to receive(:add_must_terms)
        .with(must_params)

      subject.call
    end

    it 'sends add_must_not_terms to query builder' do
      expect(query_builder)
        .to receive(:add_must_not_terms)
        .with(must_not_params)

      subject.call
    end

    it 'sends add_sort to query builder' do
      expect(query_builder)
        .to receive(:add_sort)
        .with(sort_params)

      subject.call
    end

    it 'sends add_range_filter to query builder' do
      expect(query_builder)
        .to receive(:add_range_filter)
        .with(range_params)

      subject.call
    end

    it 'creates a query' do
      expect(query_builder).to receive(:query) { expected_query }

      subject.call
    end
  end
end
