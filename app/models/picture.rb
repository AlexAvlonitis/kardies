class Picture < ApplicationRecord
  belongs_to :gallery
  belongs_to :user

  has_one_attached :picture

  validates :picture, content_type: [:png, :jpg, :jpeg, :gif]
  validates :picture, size: {
    less_than: 5.megabytes,
    message: 'Η φωτογραφία πρέπει να είναι μέχρι 5 MB'
  }

  def picture_medium
    picture.variant resize: "300x300>" if picture.attached?
  end
end
