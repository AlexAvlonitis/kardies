require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :controller do
    login_user

  let!(:user) do
    FactoryBot.create(:user, username: 'user', email: 'user@test.com')
  end

  describe 'POST #create' do
    it "create new report" do
      post :create, format: :json, params: { username: user.username }
      assert_response :success
    end
  end
end
