class MessagesController < ApplicationController
  before_action :set_user, except: [:index]

  def index
  end

  def new
    authorize @user
    @message = @user.messages.build
  end

  def create
    @message = @user.messages.build(message_params)
    @message.posted_by = current_user.id if current_user

    if @message.save
      flash[:success] = "Message has been sent."
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "Message has not been sent."
      render :new
    end
  end

  def delete_received
    @message = Message.where(id: params[:id], user_id: @user.id).first
    unless @message
      rescue_error
    else
      authorize @message
      @message.deleted_inbox = true

      if @message.save
        flash[:notice] = "Message has been deleted"
        redirect_to messages_inbox_path
      else
        flash.now[:alert] = "Message has not been been deleted"
        render :new
      end
    end
  end

  def delete_sent
    @message = Message.where(id: params[:id], posted_by: @user.id).first
    unless @message
      rescue_error
    else
      authorize @message
      @message.deleted_sent = true

      if @message.save
        flash[:notice] = "Message has been deleted"
        redirect_to messages_sent_path
      else
        flash.now[:alert] = "Message has not been been deleted"
        render :new
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:title, :body)
  end

  def set_user
    @user = User.find_by_username(params[:user_username])
  end

  def rescue_error
    flash[:alert] = 'This message cannot be deleted'
    redirect_to messages_path
  end

end
