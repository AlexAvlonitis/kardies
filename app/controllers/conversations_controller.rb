class ConversationsController < ApplicationController
  before_action :get_mailbox, :get_messages
  before_action :get_conversation, except: [:index, :delete_all]

  def index
    @conversations
    delete_conversation_notifications
  end

  def show
    if @conversation.is_deleted?(current_user)
      render json: { data: 'convo deleted' }, status: :unprocessable_entity
      return
    end
    mark_as_read

    messages = []
    @conversation.receipts_for(current_user).each do |receipt|
      messages << receipt.message
    end
    render json: messages, status: :created
  end

  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    redirect_to conversation_path(@conversation)
  end

  def destroy
    @conversation.mark_as_deleted(current_user)
    render json: @conversation, status: :created
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def delete_all
    @conversations.each do |conversation|
      conversation.mark_as_deleted(current_user)
    end
    render json: { message: 'deleted' }, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private

  def get_mailbox
    @mailbox ||= current_user.mailbox
  end

  def get_messages
    messages = @mailbox.inbox + @mailbox.sentbox
    @conversations = messages.flatten.uniq(&:id)
  end

  def get_conversation
    @conversation ||= @mailbox.conversations.find(params[:id])
  end

  def delete_conversation_notifications
    current_user.conversation_notifications.destroy_all
  end

  def mark_as_read
    @conversation.mark_as_read(current_user) if @conversation.is_unread?(current_user)
  end
end
