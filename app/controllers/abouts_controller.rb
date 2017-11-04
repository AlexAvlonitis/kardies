class AboutsController < ApplicationController
  def update
    clean_youtube_url
    @about = current_user.build_about
    save_about
  end

  private

  def about_params
    params.require(:about).permit(allow_params)
  end

  def allow_params
    %i[job hobby relationship_status looking_for description youtube_url]
  end

  def clean_youtube_url
    youtube_url = params[:about][:youtube_url]
    params[:about][:youtube_url] = youtube_url.gsub(/\s+/, '') if youtube_url
  end

  def save_about
    if @about.update(about_params)
      render json: @about, status: 200
    else
      render json: { errors: @about.errors }, status: 402
    end
  end
end
