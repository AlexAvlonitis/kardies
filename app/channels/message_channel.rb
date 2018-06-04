# Be sure to restart your server when you modify this file.
# Action Cable runs in a loop that does not support auto reloading.

class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_#{params[:conversation_id]}"
    @conversation ||= find_conversation(params[:conversation_id])
  end

  def unsubscribed; end

  def speak(data)
    if UserBlockedCheck.call(current_user, recipient)
      return MessageBroadcastJob.render_blocked(@conversation)
    end

    current_user.reply_to_conversation(@conversation, data['message'])
    MessageBroadcastJob.perform_later(@conversation)
    NotificationBroadcastJob.perform_later(@conversation, current_user)
  end

  private

  def find_conversation(conversation_id)
    current_user.mailbox.conversations.find_by(id: conversation_id)
  end

  def recipient
    participants = @conversation.participants.map { |u| u }
    participants.reject { |u| u == current_user }.first
  end
end
