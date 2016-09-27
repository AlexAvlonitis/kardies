class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Relations
  has_many :messages
  has_one :user_detail
  accepts_nested_attributes_for :user_detail

  # Validations
  validates :username, presence: true, uniqueness: true

  def full_name
    self.user_detail.first_name + " " + self.user_detail.last_name if full_name_exists?
  end

  def name
    self.user_detail.first_name if self.user_detail
  end

  def profile_picture
    self.user_detail.profile_picture.url(:thumb) if self.user_detail
  end

  def to_param
    username
  end

  private

  def full_name_exists?
    self.user_detail && self.user_detail.first_name && self.user_detail.last_name
  end
end
