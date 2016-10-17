class SessionsController < Devise::SessionsController

  def create
    super do
      set_cookie
    end
  end

  def destroy
    cookies[:user_id] = nil
    super
  end

end
