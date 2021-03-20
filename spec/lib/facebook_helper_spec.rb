require 'rails_helper'

describe FacebookHelper do
  subject { described_class.new(fb_auth) }

  let(:username) { 'tester' }
  let(:email) { 'tester@test.com' }
  let(:time) { '13:30' }
  let(:fb_auth) do
    {
      userID: username,
      email: email,
      gender: 'female'
    }
  end
  let(:expected_hash) do
    {
      confirmed_at: time,
      password: /.{20}/,
      username: /\w{3,20}/,
      uid: 'tester',
      password: /\w+/,
      email: email,
      provider: 'facebook',
      user_detail_attributes: {
        age: 30,
        gender: 'female',
        state: 'att'
      }
    }
  end

  before do
    allow(::User).to receive(:open) { image_path }
    allow(Time).to receive(:now) { time }
  end

  context 'When we pass in auth hash from fb' do
    it 'sends correct params to user.create method' do
      expect(::User).to receive(:create).with(hash_including(expected_hash))

      subject.call
    end
  end
end
