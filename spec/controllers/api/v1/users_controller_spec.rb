require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  login_user

  let(:user2) do
    FactoryBot.build_stubbed(:user, username: 'user2', email: 'user2@test.com')
  end

  describe 'GET #index' do
    it "renders the index template" do
      get :index
      assert_response :success
    end
  end

  describe 'GET #show' do
    it "renders the #show view" do
      get :show, params: { username: 'asd' }
      assert_response :success
    end

    context 'when the current_user does not have a picture' do
      before do
        @user.user_detail.update!(profile_picture: nil)
      end

      it "can't view other profiles" do
        req = get :show, params: { username: user2.username }
        expect(req).to redirect_to(users_path)
      end

      it "can view his own profile" do
        req = get :show, params: { username: @user.username }
        expect(req).not_to redirect_to(users_path)
      end
    end

    context 'when the user is blocked' do
      before do
        @user.blocked_users.build(blocked_user_id: user2.id).save!
      end

      it "can't view the profile" do
        req = get :show, params: { username: user2.username }
        expect(req).to redirect_to(users_path)
      end

      it "can view his own profile" do
        req = get :show, params: { username: @user.username }
        expect(req).not_to redirect_to(users_path)
      end
    end
  end
end
