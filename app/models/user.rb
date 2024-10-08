class User < ApplicationRecord
  include ActiveModel::Validations
  include Searchable
  include Heartable

  acts_as_votable
  acts_as_voter
  acts_as_messageable

  ALPHANUMERIC_REGEX  = /\A[a-z0-9A-Z\_]+\Z/
  USERNAME_LENGTH_MAX = 20
  USERNAME_LENGTH_MIN = 3

  scope :except_user, ->(user) { where.not(id: user) }
  scope :confirmed,   -> { where.not(confirmed_at: nil) }

  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Relations
  with_options dependent: :destroy do |assoc|
    assoc.has_one  :about
    assoc.has_one  :user_detail
    assoc.has_one  :email_preference
    assoc.has_one  :gallery
    assoc.has_one  :search_criterium
    assoc.has_one  :membership
    assoc.has_many :reports
    assoc.has_many :vote_notifications
    assoc.has_many :blocked_users
  end
  has_many :pictures, through: :gallery
  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all
  accepts_nested_attributes_for :user_detail

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

  # Validations
  validates :user_detail, :username, :email, presence: true
  validates :username, uniqueness: true
  validates :username, format: { with: ALPHANUMERIC_REGEX }
  validates :username, length: { in: USERNAME_LENGTH_MIN..USERNAME_LENGTH_MAX }
  validates_with Validators::BlackListValidator
  validates_email_format_of :email, message: 'Λάθος email'

  def to_param
    username
  end

  def mailboxer_email(_object)
    email
  end

  def after_confirmation
    UserDecorator.new(self).after_confirmation
  end
end
