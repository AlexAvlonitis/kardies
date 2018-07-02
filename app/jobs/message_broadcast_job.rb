class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation)
    broadcast(conversation)
  end

  def broadcast(conversation)
    ActionCable.server.broadcast(
      "conversation_#{conversation.id}",
      message: render_message(conversation)
    )
  end

  def self.render_blocked(conversation)
    render_blocked = ApplicationController
                     .renderer
                     .render(partial: 'conversations/blocked')

    ActionCable.server.broadcast(
      "conversation_#{conversation.id}",
      message: render_blocked
    )
  end

  def render_message(conversation)
    ApplicationController
      .renderer
      .render(partial: 'conversations/message',
              locals: { message: conversation.messages.last,
                        conversation: conversation })
  end
end
