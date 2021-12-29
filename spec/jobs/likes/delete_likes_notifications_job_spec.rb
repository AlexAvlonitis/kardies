require 'rails_helper'

RSpec.describe Likes::DeleteLikesNotificationsJob, type: :job do
  let(:current_user) { FactoryBot.build_stubbed(:user) }

  before do
    allow(current_user).to receive_message_chain(:vote_notifications, :destroy_all)
  end

  describe "#perform" do
    ActiveJob::Base.queue_adapter = :test

    it 'destroys the user\'s notifications' do
      expect(current_user).to receive_message_chain(:vote_notifications, :destroy_all)

      described_class.perform_now(current_user)
    end
  end
end
