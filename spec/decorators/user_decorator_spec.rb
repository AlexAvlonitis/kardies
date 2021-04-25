require 'rails_helper'

RSpec.describe UserDecorator do
  subject { described_class.new(user) }
  let(:user) { FactoryBot.build(:user) }

  it { is_expected.to respond_to(:profile_picture) }
  it { is_expected.to respond_to(:profile_picture_medium) }
  it { is_expected.to respond_to(:profile_picture_thumb) }
end
