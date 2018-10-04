module Api
  module V1
    class ConversationsController < ApiController
      after_action :delete_conversation_notifications, only: :index

      def index
        render json: conversations, status: :ok
      end

      def show
        if conversation.is_deleted?(current_user)
          render json: { data: 'Η συνομιλία έχει διαγραφεί' }, status: :unprocessable_entity
          return
        end
        mark_as_read

        messages = conversation.receipts_for(current_user).map do |receipt|
          receipt.message
        end
        render json: messages, status: :created
      end

      def destroy
        conversation.mark_as_deleted(current_user)
        render json: conversation, status: :created
      end

      def delete_all
        conversations.each { |convo| convo.mark_as_deleted(current_user) }
        render json: { message: 'Οι συνομηλίες διαγράφηκαν' }, status: :ok
      end

      private

      def conversations
        @conversations ||= conversations_service.all
      end

      def conversation
        @conversation ||= conversations_service.show(params[:id])
      end

      def delete_conversation_notifications
        current_user.conversation_notifications.destroy_all
      end

      def mark_as_read
        return unless conversation.is_unread?(current_user)
        conversation.mark_as_read(current_user)
      end

      def conversations_service
        @conversations_service ||= Services::Conversations.new(current_user)
      end
    end
  end
end
