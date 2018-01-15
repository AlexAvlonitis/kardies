class UserDetail < ApplicationRecord
  belongs_to :user
  after_update :flush_age_cache, :flush_profile_picture_cache

  VALID_IMAGES_REGEX = /^image\/(jpeg|jpg|png|gif|tiff)$/

  update_index('user_details#user_detail') { self }
  update_index 'users#user' do
    previous_changes['user_id'] || user
  end

  has_attached_file :profile_picture,
                    source_file_options: { all: '-auto-orient' },
                    styles: {
                      original: '',
                      medium: '300x300>',
                      thumb: '100x100>'
                    },
                    default_url: '/images/missing.png'

  validates_attachment_content_type :profile_picture, content_type: %r{\Aimage\/.*\Z}
  validates_attachment :profile_picture,
                       size: { in: 0..5.megabytes },
                       content_type: { content_type: VALID_IMAGES_REGEX }

  validates :city,
            :age,
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
              in: GC.states.map { |s| s[1] },
              message: '%<value>s is not a valid state'
            }

  validates :age, inclusion: {
    in: (18..99).map(&:to_s),
    message: '%<value>s is not a valid age, must be between 18 and 99'
  }

  private

  def flush_age_cache
    Rails.cache.delete([:user_detail, id, :age]) if age_changed?
  end

  def flush_profile_picture_cache
    Rails.cache.delete([:user_detail, id, :profile_picture]) if profile_picture?
  end
end
