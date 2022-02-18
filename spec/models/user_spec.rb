require 'rails_helper'

RSpec.describe User do
  subject { FactoryBot.build_stubbed(:user) }

  it { is_expected.to have_db_index(:email) }
  it { is_expected.to have_db_index(:username) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:email) }

  it { should have_many(:reports).dependent(:destroy) }
  it { should have_many(:vote_notifications).dependent(:destroy) }
  it { should have_many(:blocked_users).dependent(:destroy) }
  it { should have_one(:search_criterium).dependent(:destroy) }
  it { should have_one(:gallery).dependent(:destroy) }
  it { should have_one(:email_preference).dependent(:destroy) }
  it { should have_one(:user_detail).dependent(:destroy) }
  it { should have_one(:membership).dependent(:destroy) }
  it { should have_one(:about).dependent(:destroy) }

  describe 'db persistense' do
    subject { FactoryBot.build(:user) }

    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:username) }
      it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    end

    it 'does not allow username with spaces' do
      error = "Κάτι πήγε στραβά, δοκιμάστε ξανά χωρίς " \
              "κενά και μόνο αγγλικούς χαρακτήρες στο ψευδώνυμο"
      subject.update(username: 'test test')

      expect{subject.save!}.to raise_error(/#{error}/)
    end
  end
end
