module Api
  module V1
    class MessagesController < ApiController
      before_action :set_user, only: :create
      after_action  :add_notifications

      def create
        if existing_conversation
          current_user.reply_to_conversation(existing_conversation, params[:body])
        else
          current_user.send_message(
            @recipient,
            params[:body],
            current_user.username
          ).conversation
        end
        MessageBroadcastJob.perform_later(existing_conversation, current_user)

        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      rescue StandardError => e
        render json: { error: 'Κάτι πήγε στραβά, δοκιμάστε αργότερα'}, status: :unprocessable_entity
      end


      def reply
        current_user.reply_to_conversation(existing_conversation, params[:body])
        MessageBroadcastJob.perform_later(existing_conversation, current_user)

        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      rescue StandardError => e
        render json: { error: 'Κάτι πήγε στραβά, δοκιμάστε αργότερα'}, status: :unprocessable_entity
      end

      private

      def message_params
        params.permit(:recipient, :body)
      end

      def set_user
        @recipient = User.find_by!(username: params[:recipient])
        authorize(@recipient)
      end

      def add_notifications
        MessagesNotificationsBroadcastJob.perform_later(
          existing_conversation,
          current_user
        )
      end

      def existing_conversation
        @existing_conversation ||= messages.find_existing_conversation(
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
