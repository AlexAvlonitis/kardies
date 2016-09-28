class RegistrationsController < Devise::RegistrationsController

  def edit
    @user = User.find(current_user.id)
    @user.build_user_detail
    render :edit
  end

  private

  def sign_up_params
    params.require(:user).permit(:username,
                                 :email,
                                 :password,
                                 :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(allow_params)
  end

  def allow_params
    [ :username, :email, :password, :password_confirmation, :current_password,
      user_detail_attributes: [ :id, :first_name, :last_name, :city, :age,
                               :gender, :age, :profile_picture ]]
  end
end
