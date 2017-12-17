class User < ApplicationRecord
  update_index 'users#user', :self
  after_create :send_welcome_mail
  after_create :auto_like

  ALPHANUMERIC_REGEX = /\A[a-z0-9A-Z\_]*\Z/

  acts_as_votable
  acts_as_voter
  acts_as_messageable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:facebook]

  scope :all_except, ->(user) { where.not(id: user) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  # Relations
  has_one :about, dependent: :destroy
  has_one :user_detail, dependent: :destroy
  has_one :gallery, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :search_criteria, dependent: :destroy
  has_many :vote_notifications, dependent: :destroy
  has_one :email_preference, dependent: :destroy
  has_many :conversation_notifications, dependent: :destroy
  accepts_nested_attributes_for :user_detail

  # Validations
  validates :user_detail,
            :username,
            :email,
            presence: true

  validates :username, uniqueness: true
  validates :username, format: { with: ALPHANUMERIC_REGEX }
  validates :username, length: { in: 3..20 }
  validates_email_format_of :email, message: 'Λάθος email'
  validates :email, exclusion: BlockedEmail.email_list

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)
    user || create_user(auth)
  end

  def self.search(query)
    scope = UsersIndex::User.filter do
      (state == query.state) &
        (city == query.city) &
        (is_signed_in == query.is_signed_in) &
        (gender == query.gender) &
        (age >= query.age_from) & (age <= query.age_to)
    end.order(created: :desc)
    scope.only(:id).load
  end

  def self.get_all(current_user)
    includes(:user_detail)
      .all_except(current_user)
      .confirmed
      .order(created_at: :desc)
  end

  def self.get_by_state_and_prefered_gender(current_user, gender_of_interest)
    includes(:user_detail).where(
      user_details: {
        gender: gender_of_interest,
        state: current_user.state
      }
    ).all_except(current_user)
    .confirmed
    .order("RAND()")
    .limit(4)
  end

  def self.get_by_gender(current_user, gender_of_interest)
    includes(:user_detail).where(
      user_details: {
        gender: gender_of_interest
      }
    ).all_except(current_user)
    .confirmed
    .order("RAND()")
    .limit(4)
  end

  delegate :city, to: :user_detail
  delegate :state, to: :user_detail
  delegate :gender, to: :user_detail

  def job
    return unless about && about.job.present?
    Rails.cache.fetch([:about, about.id, :job], expires_in: 1.day) do
      about.job
    end
  end

  def hobby
    return unless about && about.hobby.present?
    Rails.cache.fetch([:about, about.id, :hobby], expires_in: 1.day) do
      about.hobby
    end
  end

  def relationship_status
    return unless about && about.relationship_status.present?
    Rails.cache.fetch([:about, about.id, :relationship_status], expires_in: 1.day) do
      about.relationship_status
    end
  end

  def looking_for
    return unless about && about.looking_for.present?
    Rails.cache.fetch([:about, about.id, :looking_for], expires_in: 1.day) do
      about.looking_for
    end
  end

  def description
    return unless about && about.description.present?
    Rails.cache.fetch([:about, about.id, :description], expires_in: 1.day) do
      about.description
    end
  end

  def age
    Rails.cache.fetch([:user_detail, user_detail.id, :age], expires_in: 1.day) do
      user_detail.age
    end
  end

  def profile_picture(size = :thumb)
    user_detail.profile_picture.url(size)
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

    result = update_attributes(params, *options)
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
    AutoLike.new(self).like
  end

  def self.create_user(auth)
    email = auth.info.email
    profile_picture = auth.info.image
    password = Devise.friendly_token[0, 20]
    username = create_username(auth.info.email)
    User.create(
      provider: auth.provider,
      uid: auth.uid,
      email: email,
      password: password,
      username: username,
      user_detail_attributes: {
        profile_picture: profile_picture,
        state: 'att',
        city: 'athina-ATT',
        age: 30,
        gender: 'female'
      }
    )
  end
end
