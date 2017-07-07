# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_#{params[:conversation_id]}"
  end

  def unsubscribed
  end

  def speak(data)
    decrypted_id = decrypt_obj_id(data['conversation_id'])
    conversation = find_conversation(decrypted_id)
    current_user.reply_to_conversation(conversation, data['message'])
    MessageBroadcastJob.perform_later(conversation)
    NotificationBroadcastJob.perform_later(conversation, current_user)
  end

  private

  def find_conversation(conversation_id)
    current_user.mailbox.conversations.find_by_id(conversation_id)
  end

  def decrypt_obj_id(conversation_id)
    EncryptId.new(conversation_id).decrypt
  end
end
