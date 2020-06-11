Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (needs plugins)
  orm :active_record

  api_only

  resource_owner_from_credentials do |routes|
   user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_for_authentication? { user.valid_password?(params[:password]) } && user&.active_for_authentication?
      request.env['warden'].set_user(user, scope: :user, store: false)
      user
    end
  end

  access_token_expires_in 1.day

  grant_flows %w(password)

  skip_authorization { true }

  reuse_access_token
end
