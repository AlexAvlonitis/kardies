class MessagesController < ApplicationController
  before_action :set_user

  def new
    @message = @user.messages.build
  end

  def create
    @message = @user.messages.build(message_params)

    if @message.save
      flash[:notice] = "Message has been sent."
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "Message has not been sent."
      render 'new'
    end
  end

  private

  def message_params
    params.require(:message).permit(:title, :body)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

end
