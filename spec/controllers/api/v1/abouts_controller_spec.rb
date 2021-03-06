require 'rails_helper'

RSpec.describe Api::V1::AboutsController, type: :controller do
  login_user

  let(:about_attributes) { FactoryBot.attributes_for(:about) }

  describe 'PUT #update' do
    context 'on success' do
      it "updates abouts" do
        put :update, format: :json, params: { about: about_attributes }
        assert_response :success
      end
    end

    context 'on error' do
      it "doesn't update abouts" do
        bad_params = { hello: 'world' }

        expect { put :update, format: :json, params: bad_params }
          .to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end
