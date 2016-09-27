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

  context 'methods' do
    let(:user) { FactoryGirl.create(:user) }

    context "full name complete exists" do
      it "is expected to return the full name" do
        expect(user.full_name).to eq "#{user.user_detail.first_name} #{user.user_detail.last_name}"
      end
    end

    context "full name doesn't exist" do
      it "is expected to return nothing" do
        user.user_detail.first_name = nil
        expect(user.full_name).to eq nil
      end
    end
  end

end
