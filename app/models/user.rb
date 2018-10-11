class User < ApplicationRecord
  include ActiveModel::Validations

  update_index('users#user') { self }

  after_create :send_welcome_mail
  after_create :auto_like

  ALPHANUMERIC_REGEX ||= /\A[a-z0-9A-Z\_]*\Z/

  acts_as_votable
  acts_as_voter
  acts_as_messageable

  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  scope :except_user, -> (user) { where.not(id: user) }
  scope :confirmed,   -> { where.not(confirmed_at: nil) }

  # Relations
  has_one  :about,                      dependent: :destroy
  has_one  :user_detail,                dependent: :destroy
  has_one  :email_preference,           dependent: :destroy
  has_one  :gallery,                    dependent: :destroy
  has_many :reports,                    dependent: :destroy
  has_many :search_criteria,            dependent: :destroy
  has_many :vote_notifications,         dependent: :destroy
  has_many :blocked_users,              dependent: :destroy
  has_many :conversation_notifications, dependent: :destroy
  has_many :pictures, through: :gallery
  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all
  accepts_nested_attributes_for :user_detail

  # Validations
  validates :user_detail,
            :username,
            :email,
            presence: true

  validates :username, uniqueness: true
  validates :username, format: { with: ALPHANUMERIC_REGEX }
  validates :username, length: { in: 3..20 }
  validates_with Validators::BlackListValidator
  validates_email_format_of :email, message: 'Λάθος email'

  def self.from_omniauth(auth)
    return if auth.blank?
    user = find_by(provider: 'facebook', uid: auth[:userID])
    user || create_user(auth)
  end

  def self.search(query, current_user)
    Search::Users.new(query, current_user).execute
  end

  def self.get_all
    includes(:user_detail).order(created_at: :desc)
  end

  def self.find_for_authentication(tainted_conditions)
    user = find_first_by_auth_conditions(tainted_conditions)
    user if user && user.confirmed?
  end

  def profile_picture(size = :thumb)
    user_detail.profile_picture.url(size)
  end

  def profile_picture_medium
    user_detail.profile_picture.url(:medium)
  end

  def self.picture_from_url(url)
    url ? open(url) : nil
  end

  def profile_picture_exists?
    user_detail.profile_picture.exists?
  end

  def to_param
    username
  end

  def mailboxer_email(_object)
    email
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  private

  attr_reader :nini_user

  def self.create_username(email)
    email = email.scan(/\A(.+?)@/).join.tr('.', '_')
    email_chars_count = email.split('').count
    return email.slice(0..20) if email_chars_count > 20
    email
  end

  def send_welcome_mail
    UserMailer.welcome_email(self).deliver_later
  end

  def auto_like
    likes.auto_like
  end

  def self.create_user(auth)
    email = auth[:email]
    profile_picture = picture_from_url(auth[:picture]['data']['url'])
    password = Devise.friendly_token[0, 20]
    username = create_username(auth[:email])
    User.create(
      provider: 'facebook',
      uid: auth[:userID],
      email: email,
      password: password,
      username: username,
      confirmed_at: Time.now,
      user_detail_attributes: {
        profile_picture: profile_picture,
        state: 'att',
        age: 30,
        gender: 'female'
      }
    )
  end

  def likes
    @likes ||= Services::Likes.new(self)
  end
end
