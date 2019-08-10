class User < ApplicationRecord
  include ActiveModel::Validations
  include Searchable

  after_create :send_welcome_mail
  after_create :auto_like

  # Elastic Search
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :username, type: 'keyword'
      indexes :email, type: 'keyword'
      indexes :confirmed_at, type: 'keyword'
      indexes :is_signed_in, type: 'boolean'
      indexes :created_at, type: 'date'

      indexes :user_detail, type: :object do
        indexes :state, type: 'keyword'
        indexes :age, type: 'integer'
        indexes :gender, type: 'keyword'
      end
    end
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:username, :email, :confirmed_at, :is_signed_in, :created_at],
      include: { user_detail: { only: [:state, :age, :gender] } }
    )
  end

  ALPHANUMERIC_REGEX ||= /\A[a-z0-9A-Z\_]*\Z/
  USERNAME_LENGTH_MAX = 20
  USERNAME_LENGTH_MIN = 3

  acts_as_votable
  acts_as_voter
  acts_as_messageable

  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  scope :except_user, ->(user) { where.not(id: user) }
  scope :confirmed,   -> { where.not(confirmed_at: nil) }

  # Relations
  with_options dependent: :destroy do |assoc|
    assoc.has_one  :about
    assoc.has_one  :user_detail
    assoc.has_one  :email_preference
    assoc.has_one  :gallery
    assoc.has_many :reports
    assoc.has_many :search_criteria
    assoc.has_many :vote_notifications
    assoc.has_many :blocked_users
    assoc.has_many :conversation_notifications
  end
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
  validates :username, length: { in: USERNAME_LENGTH_MIN..USERNAME_LENGTH_MAX }
  validates_with Validators::BlackListValidator
  validates_email_format_of :email, message: 'Λάθος email'

  def self.from_omniauth(auth)
    return if auth.blank?
    user = find_by(provider: 'facebook', uid: auth[:userID])
    user || FacebookHelper.create_user(auth)
  end

  def self.get_all
    includes(:user_detail).order(created_at: :desc)
  end

  def self.find_for_authentication(tainted_conditions)
    find_first_by_auth_conditions(tainted_conditions)&.confirmed?
  end

  def profile_picture(size = :thumb)
    user_detail.profile_picture.url(size)
  end

  def profile_picture_medium
    user_detail.profile_picture.url(:medium)
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

  def send_welcome_mail
    UserMailer.welcome_email(self).deliver_later
  end

  def auto_like
    likes.auto_like
  end

  def likes
    @likes ||= Services::Likes.new(self)
  end
end
