require 'rails_helper'

RSpec.describe MessagesController, type: :controller do

    describe 'GET #index' do
      let(:user) { FactoryGirl.create(:user) }

      it "renders the index template" do
        sign_in user
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'POST #create' do
      let(:user1) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:user) }
      let(:message_attributes) { FactoryGirl.attributes_for(:message) }

      before do
        sign_in user1
        post :create, params: { user_username: user1.username,
                                message: message_attributes }
      end

      context 'When is created' do
        it "assigns the create message to @message" do
          expect(assigns(:message).title).to eq message_attributes[:title]
        end

        it "redirect_to users_path on success" do
          expect(response).to redirect_to(user_path(user1))
        end

        it 'increases the count of created messages' do
          expect do
            post :create, params: { user_username: user1.username,
                                    message: message_attributes }
          end.to change(Message, :count).by(1)
        end
      end

      context 'When is not created' do
        invalid_attributes = { invalid: "", body: "test"}
        before { sign_in user1 }

        it 'does not increase the count of created messages' do
          expect do
            post :create, params: { user_username: user1.username,
                                    message: invalid_attributes }
          end.to_not change(Message, :count)
        end

        it "renders action new" do
          post :create, params: { user_username: user1.username,
                                  message: invalid_attributes }
          expect(response).to render_template :new
        end
      end
    end

end
