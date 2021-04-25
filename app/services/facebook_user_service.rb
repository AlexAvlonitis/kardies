require 'open-uri'

class FacebookUserService
  GENDERS = %w[male female].freeze
  FB_PROVIDER = 'facebook'.freeze
  DEFAULT_AGE = 30
  DEFAULT_STATE_CODE = 'att'.freeze

  def self.create_user(fb_auth)
    new(fb_auth).call
  end

  def initialize(fb_auth)
    @fb_auth = fb_auth
  end

  def call
    user = ::User.create(user_param_builder)
    create_profile_picture(user)
    user.after_confirmation
    user
  end

  private

  attr_reader :fb_auth

  def user_param_builder
    {
      provider: FB_PROVIDER,
      uid: fb_auth[:userID],
      email: fb_auth[:email],
      password: generate_password,
      username: generate_username,
      confirmed_at: time_now,
      user_detail_attributes: {
        state: DEFAULT_STATE_CODE,
        age: DEFAULT_AGE,
        gender: generate_gender
      }
    }
  end

  def generate_username
    trimmed_username = trim_username

    ::User.find_by(username: trimmed_username) ? generate_username : trimmed_username
  end

  def generate_gender
    fb_auth[:gender].present? ? fb_auth[:gender] : GENDERS.sample
  end

  def trim_username
    username.split('').first(::User::USERNAME_LENGTH_MAX).join
  end

  def username
    adjectives_array.sample + '_' + nouns_array.sample + two_random_numbers
  end

  def adjectives_array
    adjectives_file.split(/\n/).reject(&:empty?)
  end

  def nouns_array
    nouns_file.split(/\n/).reject(&:empty?)
  end

  def adjectives_file
    @adjectives_file ||= File.open("#{root_path}/lib/adjectives.txt").read
  end

  def nouns_file
    @nouns_file ||= File.open("#{root_path}/lib/nouns.txt").read
  end

  def two_random_numbers
    [*0..9].sample(2).join
  end

  def root_path
    Rails.root.to_s
  end

  def create_profile_picture(user)
    pic = picture_from_url
    return unless pic

    user.user_detail.profile_picture.attach(
      io: pic,
      filename: random_id,
      content_type: pic.content_type
    )
  rescue StandardError
    nil
  end

  def picture_from_url
    url = fb_auth.dig(:picture, :data, :url)
    return unless url

    open(url)
  end

  def generate_password
    Devise.friendly_token
  end

  def time_now
    Time.now
  end

  def random_id
    SecureRandom.uuid
  end
end
