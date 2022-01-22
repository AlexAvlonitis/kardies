require 'rails_helper'

RSpec.describe Api::V1::LikesController, type: :controller do
  login_user
  let(:user) { FactoryBot.create(:user, username: 'user1', email: 'user1@test.com') }
  let(:user2) { FactoryBot.create(:user, username: 'user2', email: 'user2@test.com') }

  let(:likes_query_result) { [user2] }
  let(:likes) do
    [
      {
        'about'  =>  nil,
        'email' => nil,
        'email_preference' => {
          'likes' => false,
          'messages' => false,
          'news' => false
        },
        'first_sign_in' => true,
        'is_signed_in' => true,
        'like' => false,
        'like_date' => 'λιγότερο από ένα λεπτό',
        'membership' => {
          'active' => nil,
          'expired' => false,
          'expiry_date' => nil
        },
        'pictures' => [],
        'profile_picture' => nil,
        'profile_picture_medium' => nil,
        'profile_picture_thumb' => nil,
        'search_criterium' => nil,
        'user_detail' => {
          'age' => user2.user_detail.age,
          'gender' => user2.user_detail.gender,
          'id' => user2.user_detail.id,
          'personality_detail' => nil,
          'personality_type' => nil,
          'state' => 'Αττικής',
          'state_code' => 'att'
        },
        'username' => user2.username
      }
    ]
  end

  before do
    allow(Likes::CreateLikesNotificationsJob).to receive(:perform_later)
    allow(Likes::DeleteLikesNotificationsJob).to receive(:perform_later)
  end

  describe '#index' do
    it 'returns the users that liked the current user' do
      @user.liked_by(user2)
      get :index, params: { page: 1 }

      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq(likes)
    end

    it 'deletes all notifications' do
      expect(Likes::DeleteLikesNotificationsJob)
        .to receive(:perform_later)
        .with(@user)

      get :index
    end

    context 'when the user is liked' do
      context 'and the voter gets deleted' do
        it 'does not return that user' do
          @user.liked_by(user)
          @user.liked_by(user2)
          user2.destroy

          get :index
          assert_response :success
          expect(@user.votes_for.size).to eq 1
        end
      end
    end
  end

  describe '#create' do
    context "when the user is already liked" do
      it "returns 409 status code" do
        allow_any_instance_of(User).to receive(:voted_for?) { true }

        post :create, params: { username: user.username }
        assert_response :conflict
      end
    end

    context "when the user is liked for the first time" do
      before do
        allow_any_instance_of(User).to receive(:voted_for?) { false }
      end

      it "returns 200 status" do
        post :create, params: { username: user.username }
        assert_response :success
      end

      it "calls the create likes notifications job" do
        expect(Likes::CreateLikesNotificationsJob)
          .to receive(:perform_later)
          .with(user, @user)

        post :create, params: { username: user.username }
      end
    end
  end
end
