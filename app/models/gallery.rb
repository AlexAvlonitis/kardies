class Gallery < ApplicationRecord
  belongs_to :user
  has_many :pictures, dependent: :destroy

  validates_presence_of :name
end
