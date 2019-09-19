# Be sure to restart your server when you modify this file.
# Action Cable runs in a loop that does not support auto reloading.

class MessagesNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_notifications_#{params[:current_user_username]}"
  end
end
