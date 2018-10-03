require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  login_user

  let!(:user2) do
    FactoryBot.create(:user, username: 'user2', email: 'user2@test.com')
  end

  describe 'GET #index' do
    it "renders the index template" do
      get :index, format: :json
      assert_response :success
    end
  end

  describe 'GET #show' do
    it "renders the #show view" do
      get :show, format: :json, params: { username: 'asd' }
      assert_response :success
    end

    context 'when the current_user does not have a picture' do
      before do
        @user.user_detail.update!(profile_picture: nil)
      end

      it "can't view other profiles" do
        response = get :show, format: :json, params: { username: user2.username }

        parsed_body = JSON.parse(response.body)
        expect(parsed_body['errors']).to eq('You need a profile pic')
      end

      it "can view his own profile" do
        req = get :show, format: :json, params: { username: @user.username }
        expect(req).not_to redirect_to(api_users_path)
      end
    end

    context 'when the user is blocked' do
      before do
        @user.blocked_users.build(blocked_user_id: user2.id).save!
      end

      it "can't view the profile" do
        response = get :show, format: :json, params: { username: user2.username }

        error = "Ενέργεια απαγορεύθηκε, υπάρχει αποκλεισμός απο την μεριά σας" \
                " ή τη μεριά του χρήστη"
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['errors']).to eq(error)
      end

      it "can view his own profile" do
        req = get :show, format: :json, params: { username: @user.username }
        expect(req).not_to redirect_to(api_users_path)
      end
    end
  end
end
