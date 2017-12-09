require 'rails_helper'

RSpec.describe AddVoteNotification do
  subject { described_class.new(user, current_user) }

  let(:user) { instance_double(User) }
  let(:current_user) { instance_double(User) }

  it 'sends a vote notification' do
    expect(subject).to receive(:create_vote_notification)
    subject.add
  end
end
