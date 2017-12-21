class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(omniauth_values)

    if @user.persisted?
      sign_in_process
    else
      session["devise.facebook_data"] = omniauth_values
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def sign_in_process
    sign_in_and_redirect @user, event: :authentication
    if is_navigational_format?
      set_flash_message(:notice, :success, kind: "Facebook")
    end
  end

  def omniauth_values
    request.env['omniauth.auth']
  end
end
