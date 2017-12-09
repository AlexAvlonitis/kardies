require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:user2) do
    FactoryBot.create(:user, username: 'zxc', email: 'zxc@zxc.com')
  end

  before do
    allow_any_instance_of(User).to receive(:auto_like) { true }
    allow_any_instance_of(User).to receive(:send_welcome_mail) { true }
  end

  describe 'GET #index' do
    before do
      sign_in user
      get :index
    end

    it "renders the index template" do
      assert_response :success
    end
  end

  describe 'GET #show' do
    before do
      sign_in user
      get :show, params: { username: user.username }
    end

    it "renders the #show view" do
      assert_response :success
    end
  end
end
