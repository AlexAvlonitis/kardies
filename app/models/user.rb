class User < ApplicationRecord
  include Searchable

  acts_as_votable
  acts_as_voter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :all_except, ->(user) { where.not(id: user) }

  # Relations
  has_many :messages
  has_one :about, dependent: :destroy
  has_one :user_detail, dependent: :destroy
  accepts_nested_attributes_for :user_detail

  # Validations
  validates :username, presence: true, uniqueness: true

  def as_indexed_json(options={})
    self.as_json(
      include: {
        user_detail: {
          only: [:gender, :city, :state]
        }
      }
    )
  end

  def full_name
    self.user_detail.first_name + " " + self.user_detail.last_name if full_name_exists?
  end

  def name
    self.user_detail.first_name
  end

  def city
    self.user_detail.city
  end

  def gender
    self.user_detail.gender
  end

  def age
    current_age(self.user_detail.age)
  end

  def state
    self.user_detail.state
  end

  def profile_picture(size = :thumb)
    self.user_detail.profile_picture.url(size)
  end

  def to_param
    username
  end

  private

  def current_age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def full_name_exists?
    self.user_detail.first_name && self.user_detail.last_name
  end
end
