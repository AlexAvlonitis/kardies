class Picture < ApplicationRecord
  belongs_to :gallery
  belongs_to :user

  has_attached_file :picture, styles: {
    medium: '300x300>',
    thumb: '100x100>'
  }

  validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}

  validates_attachment :picture,
                       size:         { in: 0..5.megabytes },
                       content_type: { content_type: %r{^image\/(jpeg|jpg|png|gif|tiff)$} }

  def picture_medium
    picture.url(:medium)
  end
end
