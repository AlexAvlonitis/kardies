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

  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
  end

  def admin_destroy
    user = User.find_by(username: params[:username])
    if current_user.admin?
      user.soft_delete
      flash['success'] = 'User has been blocked'
      redirect_to admin_reports_path
    else
      flash['alert'] = 'You do not have permission to do that'
      redirect_to root_path
    end
  end

  def admin_unblock
    user = User.find_by(username: params[:username])
    if current_user.admin?
      user.update(deleted_at: nil)
      flash['success'] = 'User has been unblocked'
      redirect_to admin_reports_path
    else
      flash['alert'] = 'You do not have permission to do that'
      redirect_to root_path
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(allow_params)
  end

  def join_username
    params[:user][:username] = params[:user][:username].split(' ').join('_')
  end

  def account_update_params
    params.require(:user).permit(allow_params)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def allow_params
    [
      :username, :email, :password, :password_confirmation, :current_password,
      user_detail_attributes: %i[
        id city state gender age profile_picture
      ]
    ]
  end
end
