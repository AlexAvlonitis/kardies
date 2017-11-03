module ConversationsHelper
  def do_not_show_current_user(conversation)
    conversation.participants.reject { |user| current_user == user }.first
  end
end
