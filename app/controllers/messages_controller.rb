class MessagesController < ApplicationController

  def new
  end

  def create
    recipient = User.find_by_username(params[:message][:username])
    conversation = current_user.send_message(recipient, params[:message][:body], params[:message][:subject]).conversation
    flash[:success] = "Message has been sent!"
    redirect_to conversation_path(conversation)
  end
end
