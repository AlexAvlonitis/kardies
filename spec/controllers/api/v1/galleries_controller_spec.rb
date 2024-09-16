require 'rails_helper'

RSpec.describe Api::V1::GalleriesController, type: :controller do
  login_user

  describe 'PATCH #update' do
    let(:user) { FactoryBot.create(:user) }
    let(:gallery) { FactoryBot.create(:gallery, user: user) }

    context 'with valid attributes' do
      it 'creates a new picture' do
        expect do
          patch :update, params: { gallery: { picture: fixture_file_upload('randomface.jpg', 'image/jpeg') } }
        end.to change(Picture, :count).by(1)
      end

      it 'returns a success response' do
        patch :update, params: { gallery: { picture: fixture_file_upload('randomface.jpg', 'image/jpeg') } }
        assert_response(:success)
      end
    end

    context 'with invalid attributes' do
      it 'returns an error response' do
        patch :update, params: { gallery: { picture: nil } }
        assert_response(:unprocessable_entity)
      end
    end
  end
end
