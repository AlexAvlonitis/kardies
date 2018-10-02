# Be sure to restart your server when you modify this file.
# Action Cable runs in a loop that does not support auto reloading.

class MessageChannel < ApplicationCable::Channel
  def subscribed
    reject unless current_user
    stream_from "conversation_#{params[:conversation_id]}"
  end

  def unsubscribed

  rescue StandardError => _e
    logger.fatal(actioncable: _e)
  end
end
