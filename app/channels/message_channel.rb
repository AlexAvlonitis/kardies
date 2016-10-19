# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_#{params[:conversation_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    conversation = find_conversation(data['conversation_id'])
    current_user.reply_to_conversation(conversation, data['message'])
    broadcast(conversation)
  end

  private

  def find_conversation(conversation_id)
    current_user.mailbox.conversations.find_by_id(conversation_id)
  end

  def broadcast(conversation)
    ActionCable.server.broadcast "conversation_#{conversation.id}", {
      message: render_message(conversation.messages.last)
    }
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'conversations/message', locals: {message: message})
  end
end
