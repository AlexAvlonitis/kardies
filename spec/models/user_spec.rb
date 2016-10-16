require 'rails_helper'

RSpec.describe User do
  subject { FactoryGirl.build(:user) }
  it { is_expected.to have_db_index(:email) }
  it { is_expected.to have_db_index(:username) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { is_expected.to validate_presence_of(:email) }
  it { should have_many(:messages) }
  it { should have_one(:user_detail) }
  it { should have_one(:about) }

end
