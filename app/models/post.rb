class Post < ApplicationRecord
  belongs_to :user
  has_many   :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 255 }

  scope :shareable, -> { where(wall_shared: true) }
end
