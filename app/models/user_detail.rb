require 'gc'

class UserDetail < ApplicationRecord
  include Searchable

  belongs_to :user

  VALID_IMAGES_REGEX = %r{^image/(jpeg|jpg|png|gif|tiff)$}.freeze

  has_one_attached :profile_picture

  validates :profile_picture, content_type: [:png, :jpg, :jpeg, :gif]
  validates :profile_picture, size: {
    less_than: 5.megabytes,
    message: 'Η φωτογραφία πρέπει να είναι μέχρι 5 MB'
  }

  validates :age,
            :gender,
            :state,
            presence: true

  validates :gender,
            inclusion: {
              in: %w[male female other],
              message: '%<value>s is not a valid gender'
            }

  validates :state,
            inclusion: {
              in: ::GC.states.map { |s| s[1] },
              message: '%<value>s is not a valid state'
            }

  validates :age, inclusion: {
    in: (18..99).map(&:to_s),
    message: '%<value>s is not a valid age, must be between 18 and 99'
  }
end
