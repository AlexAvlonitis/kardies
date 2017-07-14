class Gallery < ApplicationRecord
  belongs_to :user
  has_many :pictures, dependent: :destroy

  validates :name, presence: true
end
