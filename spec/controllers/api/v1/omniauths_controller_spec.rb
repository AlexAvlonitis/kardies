require 'rails_helper'

RSpec.describe Api::V1::OmniauthsController, type: :controller do
  let(:params) do
    {
      'email' => 'test@test.com',
      'userID' => 1,
      'picture' => 'url.png',
      'gender' => 'male'
    }
  end
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:access_token) do
    double(:access_token,
      token: 'token',
      expires_in: '2021-1-1',
      created_at: '2020-1-1'
    )
  end
  let(:expected_result) do
    {
      access_token: access_token.token,
      type: 'bearer',
      expires_in: access_token.expires_in,
      created_at: access_token.created_at
    }
  end

  describe 'GET #facebook' do
    before do
      allow(Users::CreateFacebookUserService).to receive(:call) { user }
      allow(Doorkeeper::AccessToken).to receive(:create!) { access_token }
    end

    context 'when user is found without errors' do
      before { allow(user).to receive(:persisted?) { true } }

      it 'responds with the access token' do
        get :facebook, format: :json, params: params

        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to eq(expected_result.as_json)
      end

      it 'calls the create facebook user service' do
        expect(Users::CreateFacebookUserService).to receive(:call) { user }

        get :facebook, format: :json, params: params
      end

      it 'calls the create doorkeeper access token' do
        expect(Doorkeeper::AccessToken)
          .to receive(:create!)
          .with(resource_owner_id: user.id, expires_in: 1.day)
          .and_return(access_token)

        get :facebook, format: :json, params: params
      end
    end

    context 'when user is found with errors' do
      let(:error) { { error: 'error message' } }
      let(:full_messages) { double(:errors, full_messages: [error]) }

      before do
        allow(user).to receive(:persisted?) { false }
        allow(user).to receive(:errors) { full_messages }
      end

      it 'returns the errors' do
        get :facebook, format: :json, params: params

        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to eq([error].as_json)
      end
    end
  end
end
