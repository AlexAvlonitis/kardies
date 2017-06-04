class MessagesController < ApplicationController

  def new
    @recipient = User.find_by_username(params[:username])
    redirect_to users_path if @recipient == current_user
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    recipient = User.find_by_username(params[:message][:username])
    redirect_to users_path if recipient == current_user
    existing_conversation = Mailboxer::Conversation.between(current_user, recipient).find { |c| c.participants.count == 2 }
    if existing_conversation && !existing_conversation.is_trashed?(current_user)
      current_user.reply_to_conversation(existing_conversation, params[:message][:body])
      redirect_to conversation_path(existing_conversation)
    else
      receipt = current_user.send_message(recipient, params[:message][:body], current_user.username).conversation
      flash[:success] = "Message has been sent!"
      redirect_to conversation_path(receipt)
      add_conversation_notification(recipient)
    end
  end

  private

  def add_conversation_notification(recipient)
    ConversationNotification.create(user_id: recipient.id,
                                    receiver_id: current_user.id,
                                    received: true )
    ConversationsNotificationEmail.new(recipient).send_email
  end
end
