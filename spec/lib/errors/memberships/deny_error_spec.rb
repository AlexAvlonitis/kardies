require 'rails_helper'

RSpec.describe Errors::Memberships::DenyError do
  let(:error) { described_class.new }

  describe 'message' do
    it 'returns a membership deny error message' do
      expect(error.message).to eq 'Έχετε συνδρομή ήδη.'
    end
  end
end
