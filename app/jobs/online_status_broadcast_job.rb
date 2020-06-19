class OnlineStatusBroadcastJob < ApplicationJob
  queue_as :default

  def perform(current_user, status)
    serialised_user =
      Api::V1::UserSerializer.new(current_user, scope: current_user).as_json

    ::ActionCable.server.broadcast(
        "online_status_channel",
        {
          user: serialised_user,
          online: status
        }
      )
    current_user.update!(is_signed_in: status)
  end
end
