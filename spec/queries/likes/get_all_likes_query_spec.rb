require 'rails_helper'

describe Likes::GetAllLikesQuery do
  let(:subject) { described_class.new(current_user) }

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:user2) { FactoryBot.build_stubbed(:user) }

  describe '#call' do
    it 'returns all the users likes the current user' do
      current_user.like_by(user2)
      subject.call

      expect([user2])
    end
  end
end
