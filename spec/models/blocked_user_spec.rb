require 'rails_helper'

RSpec.describe BlockedUser do
  it { is_expected.to have_db_index(:blocked_user_id) }

  it { is_expected.to validate_presence_of(:blocked_user_id) }
  it { should belong_to(:user) }
end
