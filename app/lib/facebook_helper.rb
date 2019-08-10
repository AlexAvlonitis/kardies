class FacebookHelper
  GENDERS = ['male', 'female'].freeze
  FB_PROVIDER = 'facebook'
  DEFAULT_AGE = 30
  DEFAULT_STATE_CODE = 'att'

  def self.create_user(fb_auth)
    new(fb_auth).call
  end

  def initialize(fb_auth)
    @fb_auth = fb_auth
  end

  def call
    ::User.create(user_param_builder)
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
        profile_picture: picture_from_url(fb_auth.dig(:picture, :data, :url)),
        state: DEFAULT_STATE_CODE,
        age: DEFAULT_AGE,
        gender: GENDERS.sample
      }
    }
  end

  def generate_username
    trim_username(username)
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
    File.open("#{root_path}/lib/adjectives.txt").read
  end

  def nouns_file
    File.open("#{root_path}/lib/nouns.txt").read
  end

  def two_random_numbers
    [*0..9].sample(2).join
  end

  def trim_username(username)
    username.split('').first(::User::USERNAME_LENGTH_MAX).join
  end

  def root_path
    Rails.root.to_s
  end

  def picture_from_url(url)
    ::User.send(:open, url) if url
  end

  def generate_password
    Devise.friendly_token
  end

  def time_now
    Time.now
  end
end
