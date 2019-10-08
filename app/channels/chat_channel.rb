# Be sure to restart your server when you modify this file.
# Action Cable runs in a loop that does not support auto reloading.

class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat'
  end
end
