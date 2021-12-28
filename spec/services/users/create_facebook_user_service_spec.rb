require 'rails_helper'

describe Users::CreateFacebookUserService do
  subject { described_class.new(auth_params) }

  let(:username) { 'tester' }
  let(:email) { 'tester@test.com' }
  let(:time) { '13:30' }
  let(:auth_params) do
    {
      userID: username,
      email: email,
      gender: 'female'
    }
  end
  let(:expected_hash) do
    {
      confirmed_at: time,
      password: /.{20}/,
      username: /\w{3,20}/,
      uid: 'tester',
      email: email,
      provider: 'facebook',
      user_detail_attributes: {
        age: 30,
        gender: 'female',
        state: 'att'
      }
    }
  end
  let(:user) { FactoryBot.build(:user) }

  before do
    allow(Time).to receive(:now) { time }
    allow(::User).to receive(:create).and_return(user)
    allow(user).to receive(:after_confirmation) { true }
  end

  describe '#call' do
    context 'When auth params are blank' do
      let(:auth_params) { nil }

      it 'returns nil' do
        expect(subject.call).to be_nil
      end
    end

    context 'When we pass in auth params' do
      context 'and user does not exist in the db' do
        it 'sends correct params to User#create' do
          expect(::User)
            .to receive(:create)
            .with(hash_including(expected_hash))
            .and_return(user)

          subject.call
        end

        it 'sends after_confirmation hook' do
          expect(user).to receive(:after_confirmation)

          subject.call
        end
      end

      context 'and does exists in the db' do
        before do
          allow(User).to receive(:find_by).and_return(user)
        end

        it 'returns the user found' do
          expect(User)
            .to receive(:find_by)
            .with(provider: 'facebook', uid: auth_params[:userID])
            .and_return(user)

          subject.call
        end
      end
    end
  end
end
