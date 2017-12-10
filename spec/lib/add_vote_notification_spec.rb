require 'rails_helper'

RSpec.describe AddVoteNotification do
  subject { described_class.new(user, current_user) }

  let(:user) { instance_double(User) }
  let(:current_user) { instance_double(User) }
  let(:vote_notification) do
    FactoryBot.build_stubbed(:vote_notification)
  end

  before do
    allow(user).to receive(:id) { 1 }
    allow(current_user).to receive(:id) { 2 }
  end

  it 'sends a vote notification' do
    expect(subject).to receive(:create_vote_notification)
    subject.add
  end

  it 'creates a vote notication' do
    subject.add
    v = VoteNotification.last
    expect(v.user_id).to eq vote_notification.user_id
    expect(v.voted_by_id).to eq vote_notification.voted_by_id
  end
end
