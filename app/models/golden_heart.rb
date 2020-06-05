class GoldenHeart < ApplicationRecord
  belongs_to :heartable, polymorphic: true
  belongs_to :hearter, polymorphic: true
end
