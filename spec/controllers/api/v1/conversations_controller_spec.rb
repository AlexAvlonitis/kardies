require 'rails_helper'

RSpec.describe Api::V1::ConversationsController, type: :controller do
  login_user

  let(:user2) { FactoryBot.create(:user, username: 'user2', email: 'user2@test.com') }
  before { user2.send_message(@user, 'Body', 'subject') }

  let(:conversation_result) do
    [
      {
        id: 1,
        is_read: false,
        participants: {
          email: nil,
          is_signed_in: true,
          like: false,
          like_date: nil,
          profile_picture: nil,
          profile_picture_medium: nil,
          profile_picture_thumb: nil,
          username: user2.username
        }
      }.with_indifferent_access
    ]
  end
  let(:serialized_messages) do
    [
      {
        body: 'Body',
        created_at: be_a(String),
        id: 2,
        sender: {
          email: nil,
          is_signed_in: true,
          like: false,
          like_date: nil,
          profile_picture: nil,
          profile_picture_medium: nil,
          profile_picture_thumb: nil,
          username: user2.username
        }
      }.with_indifferent_access
    ]
  end

  describe 'GET #index' do
    it 'returns all the conversations' do
      get :index, format: :json

      assert_response :success
      parsed_body = JSON.parse(response.body)

      expect(parsed_body).to eq(conversation_result)
    end
  end

  describe 'GET #show' do
    it 'renders the messages of the conversation' do
      conversation = @user.mailbox.inbox.first
      get :show, format: :json, params: { id: conversation.id }

      parsed_body = JSON.parse(response.body)

      assert_response :success
      expect(parsed_body).to match(serialized_messages)
    end

    it 'marks the conversation as read' do
      conversation = @user.mailbox.inbox.first
      get :show, format: :json, params: { id: conversation.id }

      expect(conversation.is_read?(@user)).to eq true
    end

    context 'when conversation is deleted' do
      let(:conversation) { @user.mailbox.inbox.first }

      it 'renders that it has been deleted' do
        conversation.mark_as_deleted(@user)
        get :show, format: :json, params: { id: conversation.id }

        error = 'Η συνομιλία έχει διαγραφεί'
        parsed_body = JSON.parse(response.body)

        expect(parsed_body['message']).to eq(error)
      end
    end
  end

  describe 'GET #unread' do
    it 'returns the unread conversation IDs' do
      get :unread, format: :json

      parsed_body = JSON.parse(response.body)

      assert_response :success
      expect(parsed_body).to eq([@user.mailbox.conversations.last.id])
    end
  end

  describe 'DELETE #destroy' do
    it 'marks as deleted the conversation' do
      conversation = @user.mailbox.inbox.first
      delete :destroy, format: :json, params: { id: conversation.id }

      assert_response :success
      expect(conversation.is_deleted?(@user)).to eq(true)
    end
  end

  describe 'DELETE #delete_all' do
    it 'marks as deleted all the conversations' do
      delete :delete_all, format: :json

      conversations = @user.mailbox.conversations.map { |c| c.is_deleted?(@user) }

      assert_response :success
      expect(conversations.all?(true)).to eq(true)
    end
  end
end
