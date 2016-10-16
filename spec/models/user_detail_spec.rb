require 'rails_helper'

RSpec.describe UserDetail do
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:gender) }
  it { is_expected.to validate_inclusion_of(:gender).in_array ['male', 'female'] }
  it { is_expected.to validate_presence_of(:age) }
  it { should belong_to(:user) }

  it "does not allow a state that's not in the gem list" do
    user_detail = FactoryGirl.build(:user_detail, state: 'asdasd')
    user_detail.valid?
    expect(user_detail.errors[:state].size).to eq 1
  end

end
