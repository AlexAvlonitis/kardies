class UserDetail < ApplicationRecord
  belongs_to :user, optional: true

  update_index('users#user') { user }

  has_attached_file :profile_picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\Z/

  validates_attachment :profile_picture,
    size:         { in: 0..10.megabytes },
    content_type: { content_type: /^image\/(jpeg|png|gif|tiff)$/ }

  validates_presence_of :first_name, :last_name, :city, :age, :gender, :state
  validates :gender, inclusion: { in: %w(male female),
    message: "%{value} is not a valid gender" }
  validate :states_are_included_in_the_list

  private

  def states_are_included_in_the_list
    if GC.states.select { |x| x.include?(state) }.empty?
      errors.add(:state, "state is not valid")
    end
  end

end
