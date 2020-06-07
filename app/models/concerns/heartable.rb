module Heartable
  extend ActiveSupport::Concern

  included do
    has_many :golden_hearts, as: :heartable
    has_many :golden_hearts, as: :hearter
  end
end
