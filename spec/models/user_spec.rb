require 'rails_helper'

RSpec.describe User do
  subject { FactoryBot.build(:user) }

  it { is_expected.to have_db_index(:email) }
  it { is_expected.to have_db_index(:username) }

  it { should have_many(:reports).dependent(:destroy) }
  it { should have_many(:vote_notifications).dependent(:destroy) }
  it { should have_many(:blocked_users).dependent(:destroy) }
  it { should have_one(:search_criterium).dependent(:destroy) }
  it { should have_one(:gallery).dependent(:destroy) }
  it { should have_one(:email_preference).dependent(:destroy) }
  it { should have_one(:user_detail).dependent(:destroy) }
  it { should have_one(:membership).dependent(:destroy) }
  it { should have_one(:about).dependent(:destroy) }

  describe 'validations', aggregate_failures: true do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    context 'with valid usernames' do
      ['user123', 'User456', 'username', 'user_123'].each do |username|
        it "allows username: #{username}" do
          expect{ subject.update!(username: username) }.not_to raise_error
        end
      end
    end

    context 'with invalid usernames' do
      ['user-123', 'user 123', 'user@123'].each do |username|
        it "does not allow username: #{username}" do
          expect{ subject.update!(username: username) }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
