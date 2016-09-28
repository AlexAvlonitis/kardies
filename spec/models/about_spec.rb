require 'rails_helper'

RSpec.describe About, type: :model do
  it { should belong_to(:user) }
end
