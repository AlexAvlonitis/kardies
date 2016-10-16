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
        :id, :city, :age, :state, :gender, :age, :profile_picture
      ]
    ]
  end
end
