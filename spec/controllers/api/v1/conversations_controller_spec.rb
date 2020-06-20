require 'rails_helper'

RSpec.describe Api::V1::ConversationsController, type: :controller do
  login_user

  describe 'GET #index' do
    it "renders the index template" do
      get :index, format: :json
      assert_response :success
    end
  end

  describe 'GET #show' do
    let(:user2) { FactoryBot.create(:user, username: 'user2', email: 'user2@test.com') }

    before { user2.send_message(@user, "Body", "subject") }

    it 'renders the conversation' do
      conversation = @user.mailbox.inbox.first
      get :show, format: :json, params: { id: conversation.id }
      assert_response :success
    end

    context 'when conversation is deleted' do
      let(:conversation) { @user.mailbox.inbox.first }

      it 'renders that it has been deleted' do
        conversation.mark_as_deleted(@user)
        response = get :show, format: :json, params: { id: conversation.id }
        error = 'Η συνομιλία έχει διαγραφεί'
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['message']).to eq(error)
      end
    end
  end
end
