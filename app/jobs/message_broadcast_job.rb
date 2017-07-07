class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation)
    broadcast(conversation)
  end

  def broadcast(conversation)
    encrypted_id = encrypt_obj_id(conversation.id)
    ActionCable.server.broadcast "conversation_#{encrypted_id}", {
      message: render_message(conversation)
    }
  end

  def encrypt_obj_id(conversation_id)
    EncryptId.new(conversation_id).encrypt.gsub(/\n/, "")
  end

  def render_message(conversation)
    ApplicationController.renderer
                         .render(
                           partial: 'conversations/message',
                           locals: { message: conversation.messages.last,
                                     conversation: conversation }
                          )
  end

end
