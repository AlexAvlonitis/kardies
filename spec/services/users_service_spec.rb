require 'rails_helper'

describe UsersService do
  subject { described_class.new(current_user, page) }

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:user_klass) { User }
  let(:page) { 20 }
  let(:search_criteria) do
    FactoryBot.create(:search_criterium, user: current_user)
  end
  let(:search_results) { double(:search_results) }
  let(:record_results) { double(:records_results, confirmed: []) }

  before do
    allow(search_results).to receive(:records) { record_results }
  end

  describe '#all' do
    context 'When there are no search criteria' do
      it 'returns all users from db' do
        allow(current_user).to receive(:search_criteria) { false }

        expect(user_klass).to receive_message_chain(:get_all, :except_user, :confirmed, :page)
        subject.all
      end
    end

    context 'When there are search criteria' do
      it 'returns indexed users' do
        allow(current_user).to receive(:search_criteria) { [search_criteria] }

        expect_any_instance_of(Queries::User)
          .to receive(:search)
          .with(page)
          .and_return(search_results)

        subject.all
      end
    end
  end
end
