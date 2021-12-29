require 'rails_helper'

RSpec.describe Likes::CreateLikesNotificationsJob, type: :job do
  let(:current_user) { FactoryBot.build_stubbed(:user, id: 1) }
  let(:user) { FactoryBot.build_stubbed(:user, id: 1) }

  before do
    allow(VoteNotification).to receive(:create)
  end

  describe "#perform" do
    ActiveJob::Base.queue_adapter = :test

    it 'creates a vote notefication' do
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

      expect(VoteNotification)
        .to receive(:create)
        .with(user_id: user.id, voted_by_id: current_user.id, vote: true)

      described_class.perform_now(user, current_user)
    end
  end
end
