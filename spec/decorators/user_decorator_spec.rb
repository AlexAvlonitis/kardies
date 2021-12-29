require 'rails_helper'

RSpec.describe UserDecorator do
  subject { described_class.new(user) }
  let(:user) { FactoryBot.build(:user) }
  let(:user_mailer) { double(:user_mailer) }

  before do
    allow(::News::User::CreatedJob).to receive(:perform_later)
    allow(::News::User::DestroyedJob).to receive(:perform_later)
    allow(UserMailer).to receive(:welcome_email) { user_mailer }
    allow(user_mailer).to receive(:deliver_later)
    allow(Likes::AutoLikeService).to receive(:call)
  end

  describe '#save' do
    it 'sends a welcome email' do
      expect(UserMailer).to receive(:welcome_email) { user_mailer }
      expect(user_mailer).to receive(:deliver_later)

      subject.save
    end

    it 'calls the auto_like method of the likes service' do
      expect(Likes::AutoLikeService).to receive(:call).with(user)

      subject.save
    end
  end

  describe '#after_confirmation' do
    it 'creates a created event job' do
      expect(::News::User::CreatedJob)
        .to receive(:perform_later)
        .with(user)

      subject.after_confirmation
    end
  end

  describe '#destroy' do
    it 'creates a destroyed event job' do
      expect(::News::User::DestroyedJob)
        .to receive(:perform_later)
        .with(user)

      subject.destroy
    end
  end
end
