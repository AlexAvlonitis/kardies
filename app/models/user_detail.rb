class UserDetail < ApplicationRecord
  belongs_to :user, optional: true
  after_update :flush_age_cache, :flush_profile_picture_cache

  update_index('users#user') { self }

  has_attached_file :profile_picture, styles: {
    medium: "300x300>",
    thumb: "100x100>"
  }, default_url: "https://s3-eu-west-1.amazonaws.com/imisi/user_details/profile_pictures/images/thumb/missing.png"
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\Z/

  validates_attachment :profile_picture,
    size:         { in: 0..10.megabytes },
    content_type: { content_type: /^image\/(jpeg|jpg|png|gif|tiff)$/ }

  validates_presence_of :city, :age, :gender, :state
  validates :gender, inclusion: {
    in: %w(male female other),
    message: "%{value} is not a valid gender"
  }

  validate :states_are_included_in_the_list

  validates :age, inclusion: {
    in: (16...99).map(&:to_s),
    message: "%{value} is not a valid age, must be between 16 and 99"
  }

  private

  def flush_age_cache
    Rails.cache.delete([:user_detail, id, :age]) if age_changed?
  end

  def flush_profile_picture_cache
    Rails.cache.delete([:user_detail, id, :profile_picture]) if profile_picture?
  end

  def states_are_included_in_the_list
    GC.states.select { |x| x.include?(state) }.empty?
  end

end
