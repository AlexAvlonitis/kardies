class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    handle_redirect('devise.facebook_data', 'Facebook')
  end

  private

  def handle_redirect(_session_variable, kind)
    # Use the session locale set earlier; use the default if it isn't available.
    I18n.locale = session[:omniauth_login_locale] || I18n.default_locale
    if ! omniauth_values.info.email.blank?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to root_path
    end
  end

  def user
    user = User.find_for_oauth(omniauth_values)
    add_user_details(user)
    user
  end

  private

  def add_user_details(user)
    UserDetail.find_or_create_by(user_id: user.id) do |user|
      user.state = "att"
      user.city = "athina-ATT"
      user.gender = "female"
      user.age = 30
    end
  end

  def omniauth_values
    env['omniauth.auth']
  end
end
