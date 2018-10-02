module Api
  module V1
    class ConversationsController < ApiController
      before_action :get_mailbox, :get_messages
      before_action :get_conversation, except: %i[index delete_all]
      after_action :delete_conversation_notifications, only: :index

      def index
        render json: @conversations, status: :ok
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

      def destroy
        @conversation.mark_as_deleted(current_user)
        render json: @conversation, status: :created
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unprocessable_entity
      end

      def delete_all
        @conversations.each { |convo| convo.mark_as_deleted(current_user) }
        render json: { message: 'Οι συνομηλίες διαγράφηκαν' }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unprocessable_entity
      end

      private

      def get_mailbox
        @mailbox = current_user.mailbox
      end

      def get_messages
        messages = @mailbox.inbox + @mailbox.sentbox
        @conversations = messages.flatten.uniq(&:id)
      end

      def get_conversation
        @conversation = @mailbox.conversations.find(params[:id])
      end

      def delete_conversation_notifications
        current_user.conversation_notifications.destroy_all
      end

      def mark_as_read
        return unless @conversation.is_unread?(current_user)
        @conversation.mark_as_read(current_user)
      end
    end
  end
end
