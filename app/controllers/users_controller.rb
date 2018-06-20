class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: :login

  def login; end
end
