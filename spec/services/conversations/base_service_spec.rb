require 'rails_helper'

describe Conversations::BaseService do
  let(:subject) { described_class }

  it { is_expected.to respond_to(:call) }
end
