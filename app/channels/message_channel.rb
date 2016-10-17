# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    conversation = current_user.mailbox.conversations.find_by_id(data['conversation_id'].to_i)
    current_user.reply_to_conversation(conversation, data['message'])
    ActionCable.server.broadcast "messages_#{current_user.id}", {
      message: render_message(conversation.messages.last)
    }
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'conversations/message', locals: {message: message})
  end
end
