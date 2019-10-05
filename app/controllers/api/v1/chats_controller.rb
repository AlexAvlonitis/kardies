module Api
  module V1
    class ChatsController < ApiController
      before_action :set_user, only: :create
      after_action  :add_notifications

      def index
        if conversation = existing_conversation
          current_user.reply_to_conversation(conversation, params[:body])
        else
          current_user.send_message(
            @recipient,
            params[:body],
            current_user.username
          ).conversation
        end
        MessageBroadcastJob.perform_later(conversation, current_user)

        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      end

      def reply
        conversation = existing_conversation
        current_user.reply_to_conversation(conversation, params[:body])
        MessageBroadcastJob.perform_later(conversation, current_user)

        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      end

      private

      def message_params
        params.permit(:recipient, :body)
      end

      def set_user
        @recipient = User.find_by!(username: params[:recipient])
        authorize @recipient
      end

      def add_notifications
        MessagesNotificationsBroadcastJob.perform_later(
          existing_conversation,
          current_user
        )
      end

      def existing_conversation
        messages.find_existing_conversation(
          params[:conversation_id],
          @recipient
        )
      end

      def messages
        @messages ||= Services::Messages.new(current_user)
      end
    end
  end
end
