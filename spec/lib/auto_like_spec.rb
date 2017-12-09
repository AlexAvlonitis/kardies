require 'rails_helper'

RSpec.describe AutoLike do
  subject { described_class.new(current_user) }

  let(:current_user) { instance_double(User) }
  let(:user) { instance_double(User) }
  let(:add_vote_notification) { instance_double(AddVoteNotification) }

  before do
    allow(user).to receive(:likes)
    allow(subject).to receive(:add_vote_notification)
    allow(subject).to receive(:nini_user) { user }
  end

  describe '#like' do
    it 'sends a vote' do
      expect(subject).to receive(:add_vote_notification)
      subject.like
    end

    it 'sends a like' do
      expect(subject).to receive(:nini_user)
      subject.like
    end
  end
end
