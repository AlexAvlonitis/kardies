require 'rails_helper'

RSpec.describe Api::V1::NewsController, type: :controller do
  login_user

  describe '#index' do
    it "renders the index template" do
      get :index, params: { page: 1 }
      assert_response :success
    end
  end
end
