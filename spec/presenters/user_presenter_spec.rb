require 'rails_helper'

RSpec.describe UserPresenter do
  subject { described_class.new(user) }

  let(:user_detail) { FactoryBot.build(:user_detail, :profile_picture) }
  let(:email_preference) do
    FactoryBot.build(:email_preference, messages: email_preference_messages)
  end
  let(:user) do
    FactoryBot.build(
      :user,
      is_signed_in: is_signed_in,
      user_detail: user_detail,
      email_preference: email_preference
    )
  end
  let(:is_signed_in) { false }
  let(:email_preference_messages) { true }

  let(:profile_picture_blob_regex) do
    /http:\/\/localhost:3030\/rails\/active_storage\/blobs\/.+\/test_image/
  end
  let(:profile_picture_representation_regex) do
    /http:\/\/localhost:3030\/rails\/active_storage\/representations\/.+\/test_image/
  end

  describe '#profile_picture' do
    context 'when profile picture is attached' do
      it 'returns a profile picture url blob' do
        expect(subject.profile_picture).to match profile_picture_blob_regex
      end
    end

    context 'when profile picture is not attached' do
      let(:user_detail) { FactoryBot.build(:user_detail) }

      it 'returns nil' do
        expect(subject.profile_picture).to eq nil
      end
    end
  end

  describe '#profile_picture_medium' do
    context 'when profile picture is attached' do
      it 'returns a profile picture url representation' do
        expect(subject.profile_picture_medium)
          .to match profile_picture_representation_regex
      end
    end

    context 'when profile picture is not attached' do
      let(:user_detail) { FactoryBot.build(:user_detail) }

      it 'returns nil' do
        expect(subject.profile_picture_medium).to eq nil
      end
    end
  end

  describe '#profile_picture_thumb' do
    context 'when profile picture is attached' do
      it 'returns a profile picture url representation' do
        expect(subject.profile_picture_thumb)
          .to match profile_picture_representation_regex
      end
    end

    context 'when profile picture is not attached' do
      let(:user_detail) { FactoryBot.build(:user_detail) }

      it 'returns nil' do
        expect(subject.profile_picture_thumb).to eq nil
      end
    end
  end

  describe '#message_email_notification_allowed?' do
    context 'when email preference messages is true' do
      context 'and is not signed in' do
        it 'returns true' do
          expect(subject.message_email_notification_allowed?).to eq true
        end
      end

      context 'and is signed in' do
        let(:is_signed_in) { true }

        it 'returns false' do
          expect(subject.message_email_notification_allowed?).to eq false
        end
      end
    end

    context 'when email preference messages is false' do
      let(:email_preference_messages) { false }

      context 'and is not signed in' do
        it 'returns true' do
          expect(subject.message_email_notification_allowed?).to eq false
        end
      end

      context 'and is signed in' do
        let(:is_signed_in) { true }

        it 'returns true' do
          expect(subject.message_email_notification_allowed?).to eq false
        end
      end
    end
  end

  describe '#profile_picture_attached?' do
    context 'when profile picture exists' do
      it 'returns true' do
        expect(subject.profile_picture_attached?).to eq true
      end
    end

    context 'when profile picture does not exist' do
      let(:user_detail) { FactoryBot.build(:user_detail) }

      it 'returns false' do
        expect(subject.profile_picture_attached?).to eq false
      end
    end
  end
end
