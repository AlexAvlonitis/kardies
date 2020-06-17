require 'rails_helper'

RSpec.describe Api::V1::GoldenHeartController, type: :controller do
  login_user
  let(:user) do
    FactoryBot.create(:user, username: 'user1', email: 'user1@test.com')
  end
  let(:membership) do
    FactoryBot.build_stubbed(
      :membership,
      customer_id: 'cus_123',
      subscription_id: 'sub_123'
    )
  end

  before do
    allow_any_instance_of(User).to receive(:membership).and_return(membership)
    allow(membership).to receive(:expired?) { false }
    allow(GoldenHeart).to receive(:create) { true }
    allow_any_instance_of(Notifications::Hearts).to receive(:execute) { true }
  end

  describe '#create' do
    context "When the customer exists" do
      context "and has an active membership" do
        it "returns status success" do
          post :create, params: { username: user.username }
          assert_response(:success)
        end
      end

      context "and the membership is expired" do
        it "returns status forbidden" do
          allow(membership).to receive(:expired?) { true }

          post :create, params: { username: user.username }
          assert_response(:forbidden, 'Δεν είστε χρυσό μέλος')
        end
      end

      context 'and the user has already been liked' do
        let(:golden_heart) { double(:golden_heart, find_by: user) }

        it "returns status forbidden" do
          allow_any_instance_of(User)
            .to receive(:golden_hearts)
            .and_return(golden_heart)

          post :create, params: { username: user.username }
          assert_response(:forbidden, 'Έχετε ήδη στείλει χρυσή καρδιά')
        end
      end
    end
  end
end
