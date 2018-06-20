class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!

  def login; end
end
