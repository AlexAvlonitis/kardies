class Messages::MessagesController < ApplicationController

  def index
    @messages = policy_scope(Message)
  end

  def sent
    @messages = Message.where(posted_by: current_user.id, deleted_sent: nil).all
  end

end
