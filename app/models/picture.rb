class Picture < ApplicationRecord
  belongs_to :gallery
  belongs_to :user

  has_attached_file :picture, styles: {
    medium: '300x300>',
    thumb: '100x100>'
  }

  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  validates_attachment :picture,
                       size:         { in: 0..10.megabytes },
                       content_type: { content_type: /^image\/(jpeg|jpg|png|gif|tiff)$/ }
end
