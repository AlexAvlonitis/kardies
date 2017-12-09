require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) do
    FactoryGirl.create(:user, username: 'zxc', email: 'zxc@zxc.com')
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

    it 'populates an array of users' do
      expect(assigns(:users)).to eq [user2]
    end

    it "renders the index template" do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before do
      sign_in user
      get :show, params: { username: user.username }
    end

    describe "GET #show" do
      it "assigns the requested contact to @user" do
        expect(assigns(:user)).to eq(user)
      end

      it "renders the #show view" do
        expect(response).to render_template :show
      end
    end
  end
end
