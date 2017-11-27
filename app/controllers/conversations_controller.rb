class ConversationsController < ApplicationController
  before_action :get_mailbox, :get_messages
  before_action :get_conversation, except: :index

  def index
    @conversations
    delete_conversation_notifications
  end

  def show
    redirect_to conversations_path if @conversation.is_deleted?(current_user)
    @conversation.mark_as_read(current_user) if @conversation.is_unread?(current_user)
    @hashed_conversation = EncryptId.new(@conversation.id).encrypt
  end

  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    redirect_to conversation_path(@conversation)
  end

  def destroy
    begin
      @conversation.mark_as_deleted(current_user)
      render json: @conversation, status: 201
    rescue StandardError => e
      render json: { errors: e.message }, status: 422
    end
  end

  private

  def get_mailbox
    @mailbox ||= current_user.mailbox
  end

  def get_messages
    messages = @mailbox.inbox + @mailbox.sentbox
    conversations = messages.flatten.uniq(&:id) # remove duplicate IDs
    @conversations =
      Kaminari.paginate_array(conversations).page params[:page]
  end

  def get_conversation
    @conversation ||= @mailbox.conversations.find(params[:id])
  end

  def delete_conversation_notifications
    current_user.conversation_notifications.destroy_all
  end
end
