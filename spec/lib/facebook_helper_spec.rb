require 'rails_helper'

describe FacebookHelper do
  subject { described_class.new(fb_auth) }

  let(:username) { 'tester' }
  let(:email) { 'tester@test.com' }
  let(:image_path) { '/fake/path/test.png' }
  let(:fb_auth) do
    {
      userID: username,
      email: email,
      picture: {
        data: {
          url: image_path
        }
      }
    }
  end
  let(:expected_params) do
    {
      provider: 'facebook',
      uid: username,
      email: email,
      password: /.{20}/,
      username: /w{3,20}/,
      user_detail_attributes: {
        profile_picture: image_path,
        state: 'att',
        gender: /male|female/,
        age: 30
      }
    }
  end

  before do
    allow(::User).to receive(:open) { nil }
  end

  context 'When we pass in auth hash from fb' do
    it 'sends correct params to user.create method' do
      expect(::User).to receive(:create).with(hash_including)

      subject.call
    end
  end
end
