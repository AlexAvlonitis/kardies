require 'rails_helper'

describe Memberships::UpdateMembershipService do
  let(:subject) { described_class.new(current_user) }

  let(:current_user) { double('current_user', email: 'test@test.com') }
  let(:membership) { double('membership', customer_id: 1) }
  let(:subscription) { double('subscription', id: 1) }

  describe '#call' do
  end
end
