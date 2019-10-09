require 'rails_helper'

RSpec.describe Api::V1::EmailPreferencesController, type: :controller do
  login_user

  describe "PUT #update" do
    context "when user has no email preference" do
      it "returns success" do
        put :update, format: :json, params: {email_preference: {news: true}}

        assert_response :success
      end

      it "creates and return new email preference" do
        email_preference = FactoryBot.attributes_for(:email_preference, news: true, likes: false, messages: false)
        put :update, format: :json, params: {email_preference: email_preference}
        parsed_body = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_body[:email_preference]).to match(email_preference)
      end

      it "creates new email preference with true when invalid params are passed" do
        put :update, format: :json, params: {email_preference: {invalid_params: true}}

        parsed_body = JSON.parse(response.body, symbolize_names: true)

        email_preference = FactoryBot.attributes_for(:email_preference, news: true, likes: true, messages: true)
        expect(parsed_body[:email_preference]).to match(email_preference)
      end
    end

    context "when user has aleady email preference" do
      it "updates and return updated email preference" do
        FactoryBot.create :email_preference, user_id: @user.id, likes: true, messages: true, news: true
        email_preference = FactoryBot.attributes_for(:email_preference, news: false, likes: true, messages: true)
        put :update, format: :json, params: {email_preference: email_preference}

        parsed_body = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_body[:email_preference]).to match(email_preference)
      end
    end

    context "when update failed" do
      it "returns :unprocessable_entity with errors" do
        allow_any_instance_of(EmailPreference).to receive(:update).and_return(false)
        put :update, format: :json, params: {email_preference: {"news": "test"}}

        assert_response :unprocessable_entity
      end
    end
  end
end
