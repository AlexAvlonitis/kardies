require 'rails_helper'

RSpec.describe UserDecorator do
  subject { described_class.new(user) }
  let(:user) { FactoryBot.build(:user) }

  it { is_expected.to respond_to(:profile_picture) }
  it { is_expected.to respond_to(:profile_picture_medium) }
  it { is_expected.to respond_to(:profile_picture_thumb) }
  it { is_expected.to respond_to(:after_create) }
  it { is_expected.to respond_to(:after_confirmation) }
  it { is_expected.to respond_to(:before_destroy) }
  it { is_expected.to respond_to(:message_email_notification_allowed?) }
  it { is_expected.to respond_to(:profile_picture_attached?) }
end
