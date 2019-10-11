require 'rails_helper'

RSpec.describe Api::V1::LikesController, type: :controller do
  login_user
  let(:user) { FactoryBot.create(:user, username: 'user1', email: 'user1@test.com') }

  describe '#index' do
    it "renders the index template" do
      get :index, params: { page: 1 }
      assert_response :success
    end
  end

  describe '#create' do
    context "when user is liked" do
      before do
        allow_any_instance_of(User).to receive(:voted_for?).with(user).and_return(true)
      end
      it "returns 422 status" do
        put :create, params: {username: user.username}
        assert_response :unprocessable_entity
      end
    end
    context "when user is not yet liked" do
      before do
        allow_any_instance_of(User).to receive(:voted_for?).with(user).and_return(false)
      end
      it "returns 200 status" do
        put :create, params: {username: user.username}
        assert_response :success
      end

    end
  end

end
