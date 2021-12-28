require 'rails_helper'

describe Users::GetAllUsersService do
  subject { described_class.new(current_user, page, user_elastic_query) }

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:user_elastic_query) { instance_double(Elastic::UserQuery) }
  let(:page) { 20 }
  let(:records) { double(:records) }
  let(:record_results) { double(:record_results, confirmed: []) }
  let(:search_results) { double(:search_results, records: record_results) }

  before do
    allow(user_elastic_query).to receive(:search) { search_results }
  end

  describe '#call' do
    context 'When there are no search criteria' do
      let(:user_elastic_query) { nil }

      it 'returns all users from db' do
        expect(User).to receive_message_chain(:get_all, :except_user, :confirmed, :page)

        subject.call
      end
    end

    context 'When there are search criteria' do
      it 'calls the user elastic query search' do
        expect(user_elastic_query)
          .to receive(:search)
          .with(page)
          .and_return(search_results)

        expect(search_results).to receive(:records).and_return(record_results)
        expect(record_results).to receive(:confirmed).and_return([])

        subject.call
      end
    end
  end
end
