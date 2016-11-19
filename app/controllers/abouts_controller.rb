class AboutsController < ApplicationController

  def edit
    current_user.about ? @about = current_user.about : @about = current_user.build_about
    @user = current_user
  end

  def update
    youtube_url = params[:about][:youtube_url]
    if youtube_url
      params[:about][:youtube_url] = youtube_url.gsub(/\s+/, "")
    end
    @about = current_user.build_about

    if @about.update(abouts_params)
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
    [:job, :hobby, :relationship_status, :looking_for, :description, :youtube_url]
  end
end
