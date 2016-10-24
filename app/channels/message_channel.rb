# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_#{params[:conversation_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    decrypted_id = decrypt_obj_id(data['conversation_id'])
    conversation = find_conversation(decrypted_id)
    current_user.reply_to_conversation(conversation, data['message'])
    broadcast(conversation)
  end

  private

  def find_conversation(conversation_id)
    current_user.mailbox.conversations.find_by_id(conversation_id)
  end

  def broadcast(conversation)
    encrypted_id = encrypt_obj_id(conversation.id)
    ActionCable.server.broadcast "conversation_#{encrypted_id}", {
      message: render_message(conversation)
    }
  end

  def decrypt_obj_id(conversation_id)
    EncryptId.new(conversation_id).decrypt
  end

  def encrypt_obj_id(conversation_id)
    EncryptId.new(conversation_id).encrypt.gsub(/\n/, "")
  end

  def render_message(conversation)
    ApplicationController.renderer.render(partial: 'conversations/message',
                                          locals: {message: conversation.messages.last,
                                                   conversation: conversation})
  end
end
