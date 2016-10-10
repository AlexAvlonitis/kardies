class User < ApplicationRecord
  update_index('users#user') { self }

  acts_as_votable
  acts_as_voter
  acts_as_messageable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :all_except, ->(user) { where.not(id: user) }

  # Relations
  has_one :about, dependent: :destroy
  has_one :user_detail, dependent: :destroy
  accepts_nested_attributes_for :user_detail

  # Validations
  validates :username, presence: true, uniqueness: true

  def self.search(query)
    UsersIndex::User.query(
      multi_match: {
        query: query,
        fields: [:city, :state]
      }
    ).load
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

  def mailboxer_email(object)
    self.email
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
