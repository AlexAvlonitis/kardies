module ConversationsHelper
  def remove_current_user(conversation)
    conversation.participants.reject { |user| current_user == user }.first
  end
end
