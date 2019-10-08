require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :controller do
  login_user

  describe '#create' do
    let(:user) { FactoryBot.create(:user, username: 'user1', email: 'user1@test.com') }
    context 'when user was not found' do
      before do
        allow(User).to receive(:find_by!).and_return(nil)
      end

      it 'returns 422 status' do
        post :create, format: :json, params: { username: user.username }
        assert_response :unprocessable_entity
      end
    end

    context 'when user was found' do
      before do
        allow(User).to receive(:find_by!).and_return(user)
      end

      it 'returns json report' do
        post :create, format: :json, params: { username: user.username, reason: 'γιατί όχι', description: 'ἐχω χἀσει τα αυγἀ και τα καλἀθια' }
        assert_response :success
      end
    end

    context 'when report failed to save' do
      before do
        allow(User).to receive(:find_by!).and_return(user)
        allow_any_instance_of(Report).to receive(:save).and_return nil
      end

      it 'returns 422 status' do
        post :create, format: :json, params: { username: user.username, reason: nil, description: nil }
        assert_response :unprocessable_entity
      end
    end
  end
end
