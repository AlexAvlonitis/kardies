class TermsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @user = User.new unless user_signed_in?
  end
end
