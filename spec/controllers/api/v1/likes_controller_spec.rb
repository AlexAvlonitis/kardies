require 'rails_helper'

RSpec.describe Api::V1::LikesController, type: :controller do
  login_user
  let(:user) { FactoryBot.create(:user, username: 'user1', email: 'user1@test.com') }
  let(:user2) { FactoryBot.create(:user, username: 'user2', email: 'user2@test.com') }

  describe '#index' do
    it "renders the index template" do
      get :index, params: { page: 1 }
      assert_response :success
    end

    context 'when a user is liked but the voter gets blocked and deleted' do
      it 'renders index successfully' do
        post :create, params: { username: user.username }
        post :create, params: { username: user2.username }
        BlockedEmail.create(email: user.email)
        user.destroy

        get :index, params: { page: 1 }
        assert_response :success
        expect(@user.votes.size).to eq 1
      end
    end
  end

  describe '#create' do
    context "when user is liked" do
      it "returns 422 status" do
        allow_any_instance_of(User)
          .to receive(:voted_for?)
          .with(user)
          .and_return(true)

        post :create, params: { username: user.username }
        assert_response :forbidden
      end
    end

    context "when user is not yet liked" do
      it "returns 200 status" do
        allow_any_instance_of(User)
          .to receive(:voted_for?)
          .with(user)
          .and_return(false)

        post :create, params: { username: user.username }
        assert_response :success
      end
    end
  end
end
