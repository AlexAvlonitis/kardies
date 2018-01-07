class GnorimiesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :redirect_if_signed_in

  def site_gnorimion; end

  def gnorimies_gamou; end

  def gnorimies_athina; end

  private

  def redirect_if_signed_in
    redirect_to root_path if user_signed_in?
  end
end
