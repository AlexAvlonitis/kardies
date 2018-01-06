class GnorimiesController < ApplicationController
  skip_before_action :authenticate_user!

  def site_gnorimion; end
end
