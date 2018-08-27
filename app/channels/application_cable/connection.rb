module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = authenticate!
    end

    protected

    def authenticate!
      user = User.find_by(id: access_token.try(:resource_owner_id))

      user || reject_unauthorized_connection
    end

    def access_token
      @access_token ||= Doorkeeper::AccessToken.by_token(
        request.query_parameters[:token]
      )
    end
  end
end
