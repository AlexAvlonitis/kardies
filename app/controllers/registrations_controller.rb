class RegistrationsController < Devise::RegistrationsController
  def new
    super do
      resource.build_user_detail
    end
  end

  def create
    join_username
    super do
      set_cookie(@user)
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(allow_params)
  end

  def join_username
    params[:user][:username] = params[:user][:username].split(' ').join('_')
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def account_update_params
    params.require(:user).permit(allow_params)
  end

  def allow_params
    [
      :username, :email, :password, :password_confirmation,
      user_detail_attributes: %i[
        id city state gender age profile_picture
      ]
    ]
  end
end
