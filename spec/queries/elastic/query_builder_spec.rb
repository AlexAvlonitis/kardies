require 'rails_helper'

describe Elastic::QueryBuilder do
  let(:subject) { described_class.new }

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:search_criteria) do
    FactoryBot.build_stubbed(:search_criterium, user: current_user)
  end

  let(:expected_query) { { query: query, sort: sort } }
  let(:query) do
    query = { bool: {} }
    query[:bool][:must] = must_terms if must_terms
    query[:bool][:must_not] = must_not_terms if must_not_terms
    query[:bool][:filter] = filter_terms if filter_terms
    query
  end
  let(:must_terms) do
    [
      { term: { 'user_detail.state' => search_criteria.state } },
      { term: { 'user_detail.gender' => search_criteria.gender } },
      { term: { 'is_signed_in' => search_criteria.is_signed_in } }
    ]
  end
  let(:must_not_terms) do
    [{ term: { 'username' => current_user.username } }]
  end
  let(:filter_terms) do
    {
      range: {
        "user_detail.age" => {
          gte: search_criteria.age_from,
          lte: search_criteria.age_to
        }
      }
    }
  end
  let(:sort) { [{ 'created_at' => :desc }] }
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

  describe '#add_must_terms' do
    let(:must_not_terms) { nil }
    let(:filter_terms) { nil }

    it 'adds must terms' do
      subject.add_must_terms(must_params)
      expect(subject.query).to eq({ query: { bool: { must: must_terms } } })
    end
  end

  describe '#add_must_not_terms' do
    let(:must_terms) { nil }
    let(:filter_terms) { nil }

    it 'adds must_not terms' do
      subject.add_must_not_terms(must_not_params)
      expect(subject.query).to eq({ query: { bool: { must_not: must_not_terms } } })
    end
  end

  describe '#add_filter_terms' do
    let(:must_terms) { nil }
    let(:must_not_terms) { nil }

    it 'adds filter params' do
      subject.add_range_filter(range_params)
      expect(subject.query).to eq({ query: { bool: { filter: filter_terms } } })
    end
  end

  describe '#add_sort' do
    let(:must_terms) { nil }
    let(:must_not_terms) { nil }
    let(:filter_terms) { nil }

    it 'adds sort params' do
      subject.add_sort(sort_params)
      expect(subject.query).to eq({ query: { bool: {}}, sort: sort })
    end
  end

  describe '#query' do
    it 'creates a query' do
      subject.add_must_terms(must_params)
      subject.add_must_not_terms(must_not_params)
      subject.add_range_filter(range_params)
      subject.add_sort(sort_params)

      expect(subject.query).to eq(expected_query)
    end
  end
end
