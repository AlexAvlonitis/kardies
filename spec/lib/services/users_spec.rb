require 'rails_helper'

describe Services::Users do
  subject { described_class.new(current_user, page) }

  let(:current_user) { double('current_user') }
  let(:user_klass) { User }
  let(:page) { double('page') }

  describe '#all' do
    context 'When there are no search criteria' do
      it 'returns all users from db' do
        allow(current_user).to receive(:search_criteria) { [] }

        expect(user_klass).to receive_message_chain(:get_all, :except_user, :confirmed, :page)
        subject.all
      end
    end

    context 'When there are search criteria' do
      it 'returns indexed users' do
        allow(current_user).to receive(:search_criteria) { ['present'] }

        expect(user_klass).to receive_message_chain(:search, :page, :objects)
        subject.all
      end
    end
  end
end
