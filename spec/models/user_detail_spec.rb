require 'rails_helper'

RSpec.describe UserDetail do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:gender) }
  it { is_expected.to validate_presence_of(:age) }
  it { should belong_to(:user) }


end
