class Picture < ApplicationRecord
  belongs_to :gallery
  belongs_to :user

  has_one_attached :picture

  def picture_medium
    picture.variant resize: "300x300>" if picture.attached?
  end
end
