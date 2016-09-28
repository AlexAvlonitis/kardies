class AboutsController < ApplicationController

  def edit
    current_user.about ? @about = current_user.about : @about = current_user.build_about
  end

  def update
    @about = current_user.build_about(abouts_params)

    if @about.save
      flash[:success] = "Changes have been saved."
      redirect_to edit_about_path
    else
      flash.now[:alert] = "Changes have not been saved."
      render :new
    end
  end

  private

  def abouts_params
    params.require(:about).permit(allow_params)
  end

  def allow_params
    [:job, :hobby, :relationship_status, :looking_for, :description]
  end
end
