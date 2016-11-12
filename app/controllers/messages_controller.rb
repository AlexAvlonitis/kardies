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
    current_user.send_message(recipient, params[:message][:body], params[:message][:subject]).conversation
    add_conversation_notification(recipient)
    flash[:success] = "Message has been sent!"
    redirect_to users_path
  end

  private

  def add_conversation_notification(recipient)
    ConversationNotification.create(user_id: recipient.id,
                                    receiver_id: current_user.id,
                                    received: true )
  end
end
