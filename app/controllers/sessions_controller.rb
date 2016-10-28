class SessionsController < Devise::SessionsController
  def new
    super do
      resource.build_user_detail
    end
  end
end
