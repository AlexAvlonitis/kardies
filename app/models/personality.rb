class Personality < ApplicationRecord
  validates :code, uniqueness: true
end
