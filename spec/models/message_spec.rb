require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:user) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }

  context 'methods' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:message) { FactoryGirl.create(:message,
                                  user_id: user1.id,
                                  posted_by: user2.id) }
    describe '#sender' do
      it 'should return the full name of the sender' do
        expect(message.sender).to eq user2.full_name
      end
    end

    describe '#receiver' do
      it 'should retun the full name of the receiver' do
        expect(message.receiver).to eq user1.full_name
      end
    end
  end

end
