module Api
  module V1
    class MessagesController < ApiController
      after_action :add_conversation_notification,   only: :create
      after_action :conversation_notification_email, only: :create

      def create
        @recipient = User.find_by(username: params[:recipient])
        authorize @recipient
        send_message
      end

      def reply
        conversation = find_existing_conversation
        current_user.reply_to_conversation(conversation, params[:body])
        MessageBroadcastJob.perform_later(conversation, current_user)
        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      end

      private

      def message_params
        params.permit(:recipient, :body)
      end

      def send_message
        conversation = find_existing_conversation
        if conversation && !conversation_deleted?(conversation)
          current_user.reply_to_conversation(conversation, params[:body])
        else
          current_user.send_message(
            @recipient,
            params[:body],
            current_user.username
          ).conversation
        end
        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      end

      def add_conversation_notification
        ConversationNotification.create(
          user_id: @recipient.id,
          receiver_id: current_user.id,
          received: true
        )
      end

      def conversation_notification_email
        Notifications::Conversations.new(@recipient).execute
      end

      def find_existing_conversation
        Services::Messages.find_existing_conversation(
          params[:conversation_id],
          current_user,
          @recipient
        )
      end

      def conversation_deleted?(conversation)
        Services::Messages.conversation_deleted?(
          conversation,
          current_user,
          @recipient
        )
      end
    end
  end
end
