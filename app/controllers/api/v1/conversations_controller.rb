module Api
  module V1
    class ConversationsController < ApiController
      LIMIT_MESSAGES = 50

      def index
        render json: conversations_service.all, status: :ok
      end

      def show
        if conversation.is_deleted?(current_user)
          render json: { message: 'Η συνομιλία έχει διαγραφεί' }, status: :unprocessable_entity
          return
        end
        mark_as_read

        render json: messages, status: :created
      end

      def unread
        render json: conversations_service.unread, status: :ok
      end

      def destroy
        conversation.mark_as_deleted(current_user)
        render json: conversation, status: :created
      end

      def delete_all
        conversations_service.delete_all
        render json: { message: 'Οι συνομηλίες διαγράφηκαν' }, status: :ok
      end

      private

      def mark_as_read
        return if conversation.is_read?(current_user)

        conversation.mark_as_read(current_user)
      end

      def messages
        conversation.receipts_for(current_user).last(LIMIT_MESSAGES).map(&:message)
      end

      def conversation
        @conversation ||= conversations_service.show(params[:id])
      end

      def conversations_service
        @conversations_service ||= Services::Conversations.new(current_user)
      end
    end
  end
end
