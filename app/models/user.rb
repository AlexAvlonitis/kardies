class User < ApplicationRecord
  update_index 'users#user', :self
  after_create :send_admin_mail

  acts_as_votable
  acts_as_voter
  acts_as_messageable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  scope :all_except, ->(user) { where.not(id: user) }
  scope :not_blocked, -> { where(deleted_at: nil) }

  # Relations
  has_one :about, dependent: :destroy
  has_one :user_detail, dependent: :destroy
  has_many :galleries, dependent: :destroy
  has_many :reports
  has_many :search_criteria
  has_many :vote_notifications
  has_many :conversation_notifications
  accepts_nested_attributes_for :user_detail

  # Validations
  validates :username, presence: true, uniqueness: true
  validates_format_of :username,
                      with: /\A[a-z0-9A-Z\_]*\Z/
  validates :username, length: { in: 3..40 }

  def self.find_for_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = create_username(auth.info.email)
    end
  end

  def self.search(query)
    scope = UsersIndex::User.filter{ ( state == query.state ) &
                                     ( city == query.city ) &
                                     ( is_signed_in == query.is_signed_in ) &
                                     ( gender == query.gender ) &
                                     ( age >= query.age_from ) & ( age <= query.age_to ) }
                            .order(created: :desc)
    scope.only(:id).load
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

  def state
    self.user_detail.state
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
        self.about.hobby
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

  def profile_picture(size = :thumb)
    self.user_detail.profile_picture.url(size)
  end

  def youtube_url
    self.about.youtube_url if self.about && !self.about.youtube_url.blank?
  end

  def to_param
    username
  end

  def mailboxer_email(object)
    self.email
  end

  private

  def send_admin_mail
    UserMailer.welcome_email(self).deliver_now
  end

  def self.create_username(email)
    email.scan(/\A(.+?)@/).join.gsub(".", "_")
  end
end
