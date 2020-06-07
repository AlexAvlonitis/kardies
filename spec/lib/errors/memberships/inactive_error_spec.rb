require 'rails_helper'

RSpec.describe Errors::Memberships::InactiveError do
  let(:error) { described_class.new }

  describe 'message' do
    it 'returns a membership inactive error message' do
      expect(error.message).to eq 'Δεν έχετε ενεργή συνδρομή.'
    end
  end
end
