require 'rails_helper'

RSpec.describe Errors::Memberships::UndefinedError do
  let(:error) { described_class.new }

  describe 'message' do
    it 'returns a membership undefined error message' do
      expect(error.message).to eq 'Δεν έγινε η ακύρωση, παρακαλούμε επικοινωνήστε με την τεχνική υποστήριξη.'
    end
  end
end
