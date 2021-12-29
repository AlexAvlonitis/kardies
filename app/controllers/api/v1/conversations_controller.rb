module Api
  module V1
    class ConversationsController < ApiController
      def index
        messages = Conversations::GetAllConversationsService.call(current_user.mailbox)
        render json: messages, status: :ok
      end

      def show
        if conversation.is_deleted?(current_user)
          render json: { message: 'Η συνομιλία έχει διαγραφεί' }, status: :unprocessable_entity
          return
        end
        conversation_messages =
          Conversations::GetConversationMessagesService.call(
            current_user,
            conversation
          )

        render json: conversation_messages, status: :ok
      end

      def unread
        unread_messages = Conversations::GetUnreadConversationsService.call(current_user.mailbox)
        render json: unread_messages, status: :ok
      end

      def destroy
        conversation.mark_as_deleted(current_user)
        render json: conversation, status: :ok
      end

      def delete_all
        Conversations::DeleteAllMessagesService.call(current_user)
        render json: { message: 'Οι συνομηλίες διαγράφηκαν' }, status: :ok
      end

      private

      def conversation
        @conversation ||= current_user.mailbox.conversations.find(params[:id])
      end
    end
  end
end
