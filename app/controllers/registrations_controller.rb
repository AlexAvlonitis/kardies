class RegistrationsController < Devise::RegistrationsController

  def new
    super do
      resource.build_user_detail
    end
  end

  def edit
    @user = User.find(current_user.id)
    @user.user_detail ? @user.user_detail : @user.build_user_detail
  end

  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  def admin_destroy
    user = User.find_by_username(params[:username])
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
    user = User.find_by_username(params[:username])
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

  def account_update_params
    params.require(:user).permit(allow_params)
  end

  def allow_params
    [
      :username, :email, :password, :password_confirmation, :current_password,
      user_detail_attributes: [
        :id, :city, :state, :gender, :age, :profile_picture
      ]
    ]
  end
end
