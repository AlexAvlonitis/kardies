class AboutsController < ApplicationController
  def edit
    @about = current_user.about ? current_user.about : current_user.build_about
  end

  def update
    youtube_url = params[:about][:youtube_url]
    params[:about][:youtube_url] = youtube_url.gsub(/\s+/, '') if youtube_url
    @about = current_user.build_about

    if @about.update(abouts_params)
      flash[:success] = 'Changes have been saved.'
      redirect_to edit_about_path
    else
      flash.now[:alert] = 'Changes have not been saved.'
      render :edit
    end
  end

  private

  def abouts_params
    params.require(:about).permit(allow_params)
  end

  def allow_params
    %i[job hobby relationship_status looking_for description youtube_url]
  end
end
