require 'rails_helper'

describe Users::GetAllUsersQuery do
  let(:subject) { described_class.new }

  describe '#call' do
    it 'returns all the users likes the current user' do
      expect(subject.call.to_sql)
        .to eq 'SELECT `users`.* FROM `users` ORDER BY `users`.`created_at` DESC'
    end
  end
end
