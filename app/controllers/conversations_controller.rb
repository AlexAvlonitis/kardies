class ConversationsController < ApplicationController
  before_action :get_mailbox
  before_action :get_conversation, except: [:index, :empty_trash]

  def index
    @conversations_inbox = @mailbox.inbox.page(params[:page]).per(10)
    @conversations_sent = @mailbox.sentbox.page(params[:page]).per(10)
    @conversations_trash = @mailbox.trash.page(params[:page]).per(10)
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
    @conversation.move_to_trash(current_user)
    flash[:success] = "#{ t '.convo_trashed' }"
    redirect_to conversations_path
  end

  def restore
    @conversation.untrash(current_user)
    flash[:success] = "#{ t '.convo_restored' }"
    redirect_to conversations_path
  end

  def empty_trash
    @mailbox.trash.each do |conversation|
      conversation.receipts_for(current_user).mark_as_deleted
    end
    flash[:success] = "#{ t '.trash_cleaned' }"
    redirect_to conversations_path
  end

  private

  def get_box
    if params[:box].blank? or !%w(inbox sent trash).include?(params[:box])
      params[:box] = 'inbox'
    end
    @box = params[:box]
  end

  def get_mailbox
    @mailbox ||= current_user.mailbox
  end

  def get_conversation
    @conversation ||= @mailbox.conversations.find(params[:id])
  end

  def delete_conversation_notifications
    current_user.conversation_notifications.destroy_all
  end
end
