require 'rails_helper'

RSpec.describe Api::V1::CableController, type: :controller do
  login_user

  before do
    allow(::OnlineStatusBroadcastJob).to receive(:perform_later)
  end

  describe 'POST #unsubscribe' do
    it "creates an online status broadcast job" do
      expect(::OnlineStatusBroadcastJob)
        .to receive(:perform_later)
        .with(@user, false)

      post :unsubscribe, format: :json
    end

    it "responds with status :ok" do
      post :unsubscribe, format: :json
      assert_response :success
    end
  end
end
