class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # relations
  has_many :places

  has_attached_file :profile_picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\Z/

  validates :username, presence: true, uniqueness: true

  validates_attachment :profile_picture,
    size:         { in: 0..10.megabytes },
    content_type: { content_type: /^image\/(jpeg|png|gif|tiff)$/ }

  def full_name
    self.first_name + " " + self.last_name if full_name_exists?
  end

  private

  def full_name_exists?
    self.first_name && self.last_name
  end
end
