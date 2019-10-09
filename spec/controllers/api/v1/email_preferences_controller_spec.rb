require 'rails_helper'

RSpec.describe Api::V1::EmailPreferencesController, type: :controller do
  login_user

  describe "PUT #update" do
    context "when user has no email preference" do
      it "should return success" do
        put :update, format: :json, params: {email_preference: {news: true}}

        assert_response :success
      end

      it "should create and return new email preference" do
        email_preference = {"news" => true, "likes" => false, "messages" => false}
        put :update, format: :json, params: {email_preference: email_preference}

        parsed_body = JSON.parse(response.body)
        expect(parsed_body['email_preference']).to match(email_preference)
      end

      it "should create new email preference with true when invalid params are passed" do
        put :update, format: :json, params: {email_preference: {invalid_params: true}}

        parsed_body = JSON.parse(response.body)
        expect(parsed_body['email_preference']).to match({"news" => true, "likes" => true, "messages" => true})
      end
    end

    context "when user has aleady email preference" do
      it "should update and return updated email preference" do
        email_preference = @user.build_email_preference
        email_preference.likes = true
        email_preference.messages = true
        email_preference.news = false
        email_preference.save
        email_preference = {"news" => false, "likes" => true, "messages" => true}
        put :update, format: :json, params: {email_preference: email_preference}

        parsed_body = JSON.parse(response.body)
        expect(parsed_body['email_preference']).to match(email_preference)
      end
    end

    context "when update failed" do
      it "should return :unprocessable_entity with errors" do
        allow_any_instance_of(EmailPreference).to receive(:update).and_return(false)
        put :update, format: :json, params: {email_preference: {"news": "test"}}

        assert_response :unprocessable_entity
      end
    end
  end
end
