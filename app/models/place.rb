class Place < ApplicationRecord
  belongs_to :user

  validates :country, presence: true
  validates :visit_date, presence: true
end
