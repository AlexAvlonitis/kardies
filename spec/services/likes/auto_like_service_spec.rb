require 'rails_helper'

describe Likes::AutoLikeService do
  let(:subject) { described_class.new(current_user, bot_user) }

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:bot_user) { FactoryBot.build_stubbed(:user) }

  before do
    allow(current_user).to receive(:liked_by)
    allow(Likes::CreateLikesNotificationsJob).to receive(:perform_later)
  end

  describe '#call' do
    it 'gets liked by the bot user' do
      expect(current_user).to receive(:liked_by).with(bot_user)

      subject.call
    end

    it 'creates a like notification' do
      expect(Likes::CreateLikesNotificationsJob)
        .to receive(:perform_later)
        .with(bot_user, current_user)

      subject.call
    end
  end
end
