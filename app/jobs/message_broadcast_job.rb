class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation, current_user)
    broadcast(conversation, current_user)
  end

  def broadcast(conversation, current_user)
    sender =
      Api::V1::UserSerializer.new(current_user, {scope: current_user}).as_json
    serialized_message =
      Api::V1::MessageSerializer.new(conversation.messages.last).as_json

    serialized_message[:sender] = sender

    ActionCable.server.broadcast(
      "conversation_#{conversation.id}",
      message: serialized_message
    )
  end

  def self.render_blocked(conversation)
    ActionCable.server.broadcast(
      "conversation_#{conversation.id}",
      message: 'Υπάρχει αποκλεισμός απο τον χρήστη'
    )
  end
end
