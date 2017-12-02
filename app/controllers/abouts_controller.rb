class AboutsController < ApplicationController
  def update
    @about = current_user.build_about
    save_about
  end

  private

  def about_params
    params.require(:about).permit(allow_params)
  end

  def allow_params
    %i[job hobby relationship_status looking_for description]
  end

  def save_about
    if @about.update(about_params)
      render json: @about, status: 200
    else
      render json: { errors: @about.errors }, status: 402
    end
  end
end
