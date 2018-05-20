# Be sure to restart your server when you modify this file.
# Action Cable runs in a loop that does not support auto reloading.

class MessageChannel < ApplicationCable::Channel
  def subscribed
    puts '============='
    puts "subscribed: #{params[:conversation_id]}"
    puts '==============='

    stream_from "conversation_#{params[:conversation_id]}"
  end

  def unsubscribed; end

  def speak(data)
    puts '============='
    puts "speak: #{data['conversation_id']}"
    puts '==============='

    conversation = find_conversation(data['conversation_id'])
    current_user.reply_to_conversation(conversation, data['message'])
    MessageBroadcastJob.perform_later(conversation)
    NotificationBroadcastJob.perform_later(conversation, current_user)
  end

  private

  def find_conversation(conversation_id)
    current_user.mailbox.conversations.find_by(id: conversation_id)
  end
end
