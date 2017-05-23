class EmailPreferencesController < ApplicationController
  before_action :set_email_preference

  def edit
  end

  def update
    if @email_preferences.update(email_preferences_params)
      flash[:success] = t '.settings_saved'
      redirect_to edit_email_preferences_path
    else
      flash.now[:alert] = t '.settings_not_saved'
      render :edit
    end
  end

  private

  def set_email_preference
    if current_user.email_preference
      @email_preferences = current_user.email_preference
    else
      @email_preferences = current_user.build_email_preference
    end
  end

  def email_preferences_params
    params.require(:email_preference).permit(allow_params)
  end

  def allow_params
    [:likes, :messages, :news]
  end
end
