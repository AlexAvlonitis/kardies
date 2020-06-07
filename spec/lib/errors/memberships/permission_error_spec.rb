require 'rails_helper'

RSpec.describe Errors::Memberships::PermissionError do
  let(:error) { described_class.new }

  describe 'message' do
    it 'returns a membership permission error message' do
      expect(error.message).to eq 'Απαγόρευση εντολής'
    end
  end
end
