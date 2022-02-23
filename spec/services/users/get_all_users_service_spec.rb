require 'rails_helper'

describe Users::GetAllUsersService do
  subject { described_class.new(current_user: current_user, page: page) }

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:records) { double(:records) }
  let(:page) { 20 }

  before do
    allow(User)
      .to receive_message_chain(:search, :page, :records, :confirmed, :compact)
    allow(Users::GetAllUsersQuery)
      .to receive_message_chain(:call, :except_user, :confirmed, :page)
    allow(Elastic::UserQuery).to receive(:call)
  end

  describe '#call' do
    context 'When there are no search criteria' do
      let(:current_user) { nil }

      it 'returns all users from db' do
        expect(Users::GetAllUsersQuery)
          .to receive_message_chain(:call, :except_user, :confirmed, :page)

        subject.call
      end
    end

    context 'When there are search criteria' do
      it 'calls the user elastic query search' do
        expect(User)
          .to receive_message_chain(:search, :page, :records, :confirmed, :compact)

        expect(Elastic::UserQuery)
          .to receive(:call)
          .with(
            params: current_user.search_criterium,
            current_user: current_user
          )

        subject.call
      end
    end
  end
end
