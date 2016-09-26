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
      let(:user) { FactoryGirl.create(:user) }
      let(:message_attributes) { FactoryGirl.attributes_for(:message) }

      before do
        sign_in user
        post :create, params: { user_username: user.username,
                                message: message_attributes }
      end

      context 'When is created' do
        it "assigns the create message to @message" do
          expect(assigns(:message).title).to eq message_attributes[:title]
        end

        it "redirect_to users_path on success" do
          expect(response).to redirect_to(user_path(user))
        end

        it 'increases the count of created messages' do
          expect do
            post :create, params: { user_username: user.username,
                                    message: message_attributes }
          end.to change(Message, :count).by(1)
        end
      end

      context 'When is not created' do
        invalid_attributes = { invalid: "", body: "test"}

        it 'does not increase the count of created messages' do
          expect do
            post :create, params: { user_username: user.username,
                                    message: invalid_attributes }
          end.to_not change(Message, :count)
        end

        it "renders action new" do
          post :create, params: { user_username: user.username,
                                  message: invalid_attributes }
          expect(response).to render_template :new
        end
      end
    end

    describe 'DELETE #delete_received' do
      let(:user1) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:user) }
      let(:message) { FactoryGirl.create(:message,
                                          user_id: user1.id,
                                          posted_by: user2.id) }

      before { sign_in user1 }

      context 'When is deleted' do
        before { delete :delete_received, params: { user_username: user1.username,
                                                    id: message.id } }
        it "assigns deleted_inbox to true for @message" do
          expect(assigns(:message).deleted_inbox).to eq true
        end

        it "redirect_to users_path on success" do
          expect(response).to redirect_to(messages_inbox_path)
        end
      end

      context 'When is not deleted' do
        it "redirects to message index" do
          delete :delete_received, params: { user_username: user1.username,
                                             id: 123 }
          expect(response).to redirect_to(messages_path)
        end
      end

    end

    describe 'DELETE #delete_sent' do
      let(:user1) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:user) }
      let(:message) { FactoryGirl.create(:message,
                                          user_id: user1.id,
                                          posted_by: user2.id) }

      before { sign_in user2 }

      context 'When is deleted' do
        before { delete :delete_sent, params: { user_username: user2.username,
                                                id: message.id } }
        it "assigns deleted_sent to true for @message" do
          expect(assigns(:message).deleted_sent).to eq true
        end

        it "redirect_to users_path on success" do
          expect(response).to redirect_to(messages_sent_path)
        end
      end

      context 'When is not deleted' do
        it "redirects to message index" do
          delete :delete_sent, params: { user_username: user1.username,
                                             id: 123 }
          expect(response).to redirect_to(messages_path)
        end
      end

    end




end
