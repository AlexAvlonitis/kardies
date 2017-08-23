class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    handle_redirect('devise.facebook_data', 'Facebook')
  end

  private

  def handle_redirect(_session_variable, kind)
    # Use the session locale set earlier; use the default if it isn't available.
    I18n.locale = session[:omniauth_login_locale] || I18n.default_locale
    if omniauth_values.info.email.present?
      user = find_user
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to root_path
    end
  end

  def find_user
    User.find_for_oauth(omniauth_values)
  end

  def omniauth_values
    request.env['omniauth.auth']
  end
end
