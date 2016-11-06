class User < ApplicationRecord
  update_index('users#user') { self }

  acts_as_votable
  acts_as_voter
  acts_as_messageable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :all_except, ->(user) { where.not(id: user) }
  scope :not_blocked, -> { where(deleted_at: nil) }

  # Relations
  has_one :about, dependent: :destroy
  has_one :user_detail, dependent: :destroy
  has_many :galleries, dependent: :destroy
  has_many :reports
  accepts_nested_attributes_for :user_detail

  # Validations
  validates :username, presence: true, uniqueness: true
  validates_format_of :username,
                      with: /\A[^\.]*\Z/,
                      message: "Should not contain dot!"
  validates :username, length: { in: 3..18 }

  def self.search(query)
    scope = UsersIndex::User
              .filter{ deleted_at != true }
              .filter{ state == query[:state] }
              .filter{ city == query[:city] }
              .filter{ username == query[:username] }
              .filter{ is_signed_in == query[:is_signed_in] }
              .filter{ gender == query[:gender] }
              .filter{ age_values(query) }
    scope.only(:id).load
  end

  def age_values(query)
    if query.has_key?(:age)
      (age >= query[:age][0]) & (age <= query[:age][1])
    else
      (age >= query[:age]) & (age <= query[:age])
    end
  end

  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  def city
    self.user_detail.city
  end

  def gender
    self.user_detail.gender
  end

  def job
    if self.about && !self.about.job.blank?
      Rails.cache.fetch([:about, about.id, :job], expires_in: 1.day) do
        self.about.job
      end
    end
  end

  def hobby
    if self.about && !self.about.hobby.blank?
      Rails.cache.fetch([:about, about.id, :hobby], expires_in: 1.day) do
        self.about.job
      end
    end
  end

  def relationship_status
    if self.about && !self.about.relationship_status.blank?
      Rails.cache.fetch([:about, about.id, :relationship_status], expires_in: 1.day) do
        self.about.relationship_status
      end
    end
  end

  def looking_for
    if self.about && !self.about.looking_for.blank?
      Rails.cache.fetch([:about, about.id, :looking_for], expires_in: 1.day) do
        self.about.looking_for
      end
    end
  end

  def description
    if self.about && !self.about.description.blank?
      Rails.cache.fetch([:about, about.id, :description], expires_in: 1.day) do
        self.about.description
      end
    end
  end

  def age
    Rails.cache.fetch([:user_detail, user_detail.id, :age], expires_in: 1.day) do
      self.user_detail.age
    end
  end

  def state
    self.user_detail.state
  end

  def profile_picture(size = :thumb)
    Rails.cache.fetch([:user_detail, user_detail.id, :profile_picture], expires_in: 1.day) do
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
