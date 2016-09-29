class SessionsController < Devise::SessionsController
  def create
    super do
      resource.is_signed_in = true
      resource.save
    end
  end

  def destroy
    current_user.is_signed_in = false
    current_user.save
    super
  end
end
