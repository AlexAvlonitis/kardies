require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  login_user

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
  end
end
