require 'rails_helper'

RSpec.describe UserDetail do
  it { should belong_to(:user) }

  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:gender) }
  it { is_expected.to validate_presence_of(:age) }

  describe 'state' do
    it "does not allow a state that's not in the gem list" do
      user_detail = FactoryGirl.build(:user_detail, state: 'asdasd')
      expect(user_detail).not_to be_valid
    end

    it 'allows states from the gem list' do
      %w(att ait ker thess).each do |state|
        user_detail = FactoryGirl.build(:user_detail, state: state)
        expect(user_detail).to be_valid
      end
    end
  end

  describe 'gender' do
    it "does not allow a gender that's not in the list" do
      user_detail = FactoryGirl.build(:user_detail, gender: 'asdasd')
      expect(user_detail).not_to be_valid
    end

    it "allows a gender that's in the list" do
      %w(male female other).each do |gender|
        user_detail = FactoryGirl.build(:user_detail, gender: gender)
        expect(user_detail).to be_valid
      end
    end
  end

  describe 'age' do
    it "does not allow age that's not in the range" do
      %w(17 15 100).each do |age|
        user_detail = FactoryGirl.build(:user_detail, age: age)
        expect(user_detail).not_to be_valid
      end
    end

    it "allows age that's in the range" do
      %w(18 34 99).each do |age|
        user_detail = FactoryGirl.build(:user_detail, age: age)
        expect(user_detail).to be_valid
      end
    end
  end
end
