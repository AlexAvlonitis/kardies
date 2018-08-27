class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation)
    broadcast(conversation)
  end

  def broadcast(conversation)
    serialized_message =
      Api::V1::MessageSerializer.new(conversation.messages.last).as_json

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
