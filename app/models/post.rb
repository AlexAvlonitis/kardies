class Post < ApplicationRecord
  belongs_to :user
  has_many   :comments, as: :commentable, dependent: :destroy
  has_many   :votes, class_name: 'ActsAsVotable::Vote', as: :votable, dependent: :destroy

  acts_as_votable

  validates :body, presence: true, length: { maximum: 255 }

  scope :shareable, -> { where(wall_shared: true) }
end
