require 'rails_helper'

RSpec.describe Admin::ApplicationController, type: :controller do

  describe "GET #index" do
    let(:user) { FactoryGirl.create(:user, admin: true) }

    before do
      allow_any_instance_of(User).to receive(:auto_like) { true }
      allow_any_instance_of(User).to receive(:send_welcome_mail) { true }
      sign_in user
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
