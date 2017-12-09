require 'rails_helper'

RSpec.describe User do
  subject { FactoryGirl.build_stubbed(:user) }

  it { is_expected.to have_db_index(:email) }
  it { is_expected.to have_db_index(:username) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:email) }
  it { should have_many(:messages) }
  it { should have_one(:gallery) }
  it { should have_one(:user_detail) }
  it { should have_one(:about) }

 describe 'persistense in db' do
   subject { FactoryGirl.build(:user) }

   before do
     allow(subject).to receive(:auto_like) { true }
   end

   context 'uniqueness' do
     it { is_expected.to validate_uniqueness_of(:username) }
     it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
   end

   context 'callbacks' do
     it 'sends an auto like after creation' do
       expect(subject).to receive(:auto_like)
       subject.save
     end
   end
 end
end
