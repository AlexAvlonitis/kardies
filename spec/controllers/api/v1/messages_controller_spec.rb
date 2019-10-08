require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do

  login_user

  let!(:recipient) do
    FactoryBot.create(:user, username: 'recipient', email: 'recipient@user.com')
  end

  let(:conversation) do
    @user.send_message(
      recipient,
      'first message',
      @user.username
    ).conversation
  end


  before(:all) do
    ActiveJob::Base.queue_adapter = :test
  end

  describe 'POST #create' do
    context 'when a conversation already exists' do
      it 'adds the message to the conversation' do
        expect {
          post(
            :create,
            format: :json,
            params: {
              body: 'hello',
              recipient: recipient.username,
              conversation_id: conversation.id
            }
          )

          assert_response :success
        }.to change { conversation.messages.count }.by(1)
      end
    end

    context 'when there is no conversation' do
      it 'sends the message and creates a conversation' do
        expect {
          post(
            :create,
            format: :json,
            params: {
              body: 'hello',
              recipient: recipient.username
            }
          )


          assert_response :success
        }.to change { Mailboxer::Conversation.count }.by(1)
      end
    end

    it 'enqueues a message broadcast job' do
      expect {
        post :create, format: :json, params: { body: 'hello', recipient: recipient.username }
      }.to have_enqueued_job(MessageBroadcastJob)
    end

    it 'returns success' do
      post :create, format: :json, params: { body: 'hello', recipient: recipient.username }

      assert_response :success

      expected_data = 'μήνυμα εστάλει'
      parsed_body = JSON.parse(response.body)

      expect(parsed_body['data']).to eq(expected_data)
    end
  end

  describe 'POST #reply' do
    it 'adds the message to the conversation' do
      expect {
        post(
          :create,
          format: :json,
          params: {
            body: 'hello',
            recipient: recipient.username,
            conversation_id: conversation.id
          }
        )

        assert_response :success
      }.to change { conversation.messages.count }.by(1)
    end

    it 'enqueues a message broadcast job' do
      expect {
        post :create, format: :json, params: { body: 'hello', recipient: recipient.username }
      }.to have_enqueued_job(MessageBroadcastJob)
    end

    it 'returns success' do
      post :create, format: :json, params: { body: 'hello', recipient: recipient.username }

      assert_response :success

      expected_data = 'μήνυμα εστάλει'
      parsed_body = JSON.parse(response.body)

      expect(parsed_body['data']).to eq(expected_data)
    end
  end
end
