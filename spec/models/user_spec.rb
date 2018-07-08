require 'rails_helper'

RSpec.describe User do
  subject { FactoryBot.build_stubbed(:user) }

  it { is_expected.to have_db_index(:email) }
  it { is_expected.to have_db_index(:username) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:email) }

  it { should have_many(:reports).dependent(:destroy) }
  it { should have_many(:search_criteria).dependent(:destroy) }
  it { should have_many(:vote_notifications).dependent(:destroy) }
  it { should have_many(:conversation_notifications).dependent(:destroy) }
  it { should have_one(:gallery).dependent(:destroy) }
  it { should have_one(:email_preference).dependent(:destroy) }
  it { should have_one(:user_detail).dependent(:destroy) }
  it { should have_one(:about).dependent(:destroy) }

  describe 'db persistense' do
    subject { FactoryBot.build(:user) }

    before do
      allow(subject).to receive(:auto_like) { true }
      allow(UserMailer)
        .to receive_message_chain(:welcome_email, :deliver_later)
        .and_return(true)
    end

    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:username) }
      it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    end

    context 'callbacks' do
      it 'calls #auto_like after creation' do
        expect(subject).to receive(:auto_like)
        subject.save
      end

      it 'calls #send_welcome_mail after creation' do
        expect(subject).to receive(:send_welcome_mail)
        subject.save
      end
    end

    it 'does not allow username with spaces' do
      error = "Κάτι πήγε στραβά, δοκιμάστε ξανά χωρίς " \
              "κενά και μόνο λατινικούς χαρακτήρες στο ψευδώνυμο"
      subject.update(username: 'test test')

      expect{subject.save!}.to raise_error(/#{error}/)
    end
  end
end
