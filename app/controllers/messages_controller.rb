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
    @recipient ||= User.find_by_username(params[:message][:username])
    redirect_to users_path if @recipient == current_user
    existing_conversation = find_existing_conversation
    if existing_conversation && !existing_conversation.is_trashed?(current_user)
      current_user.reply_to_conversation(existing_conversation, params[:message][:body])
      add_conversation_notification
      conversation_notification_email
      redirect_to conversation_path(existing_conversation)
    else
      receipt = current_user.send_message(@recipient, params[:message][:body], current_user.username).conversation
      flash[:success] = "Message has been sent!"
      redirect_to conversation_path(receipt)
      add_conversation_notification
      conversation_notification_email
    end
  end

  private
  attr_reader :conversation_notification_email

  def add_conversation_notification
    ConversationNotification.create(user_id: @recipient.id,
                                    receiver_id: current_user.id,
                                    received: true )
  end

  def conversation_notification_email
    @conversation_notification_email ||=
      ConversationsNotificationEmail.new(@recipient).send_email
  end

  def find_existing_conversation
    Mailboxer::Conversation.between(current_user, @recipient)
                           .find { |c| c.participants.count == 2 }
  end
end
