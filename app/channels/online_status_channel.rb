# Be sure to restart your server when you modify this file.
# Action Cable runs in a loop that does not support auto reloading.

class OnlineStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "online_status_channel"
    return if current_user.is_signed_in

    ::OnlineStatusBroadcastJob.perform_later(current_user, true)
  end

  def unsubscribed
    return unless current_user.is_signed_in

    ::OnlineStatusBroadcastJob.perform_later(current_user, false)
  end
end
