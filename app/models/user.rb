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
  has_many :galleries, dependent: :destroy
  accepts_nested_attributes_for :user_detail

  # Validations
  validates :username, presence: true, uniqueness: true
  validates_format_of :username,
                      :with => /\A[^\.]*\Z/,
                      :message => "should not contain dot!"

  def self.search(query)
    UsersIndex::User.query(
      multi_match: {
        query: query,
        fields: [:city, :state]
      }
    ).load
  end

  def city
    self.user_detail.city
  end

  def gender
    self.user_detail.gender
  end

  def job
    self.about.job if self.about && !self.about.job.blank?
  end

  def hobby
    self.about.job if self.about && !self.about.hobby.blank?
  end

  def relationship_status
    self.about.relationship_status if self.about && !self.about.relationship_status.blank?
  end

  def looking_for
    self.about.looking_for if self.about && !self.about.looking_for.blank?
  end

  def description
    self.about.description if self.about && !self.about.description.blank?
  end

  def age
    Rails.cache.fetch([:user_detail, user_detail.id, :age], expires_in: 30.minutes) do
      self.user_detail.age
    end
  end

  def state
    self.user_detail.state
  end

  def profile_picture(size = :thumb)
    Rails.cache.fetch([:user_detail, user_detail.id, :profile_picture], expires_in: 30.minutes) do
      self.user_detail.profile_picture.url(size)
    end
  end

  def to_param
    username
  end

  def mailboxer_email(object)
    self.email
  end
end
