require 'rails_helper'

RSpec.describe AboutsController, type: :controller do
  login_user

  let(:about_attributes) { FactoryBot.attributes_for(:about) }

  describe 'PUT #update' do
    context 'on success' do
      it "updates abouts" do
        put :update, params: { about: about_attributes }
        assert_response :success
      end
    end

    context 'on error' do
      it "doesn't update abouts" do
        bad_params = { hello: 'world' }

        put :update, params: bad_params
        assert_response :internal_server_error
      end
    end
  end
end
