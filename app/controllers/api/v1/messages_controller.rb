module Api
  module V1
    class MessagesController < ApiController
      before_action :set_user, only: :create

      def create
        if conversation
          current_user.reply_to_conversation(conversation, params[:body])
        else
          current_user.send_message(
            @recipient,
            params[:body],
            current_user.username
          ).conversation
        end
        ::MessageBroadcastJob.perform_later(conversation, current_user)

        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      rescue StandardError => e
        render json: { error: 'Κάτι πήγε στραβά, δοκιμάστε αργότερα'}, status: :unprocessable_entity
      end


      def reply
        current_user.reply_to_conversation(conversation, params[:body])
        ::MessageBroadcastJob.perform_later(conversation, current_user)

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

      def conversation
        @conversation ||=
          Conversations::FindExistingConversationService.call(
            current_user,
            params[:conversation_id],
            @recipient
          )
      end
    end
  end
end
