module ConversationsHelper
  def reject_if_less_than_one_participant(conversation)
    if conversation.participants.count > 1
      conversation.participants.reject { |user| current_user == user }.first
    end
  end
end
