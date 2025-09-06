module Api
  module V1
    class MessagesController < ApiController
      before_action :set_user, only: :create
      before_action :validate_message_limits, only: [:create, :reply]

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
        add_notifications
        current_user.increment_action_count!('message')

        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      rescue StandardError
        render json: { error: 'Κάτι πήγε στραβά, δοκιμάστε αργότερα'}, status: :unprocessable_entity
      end

      def reply
        current_user.reply_to_conversation(conversation, params[:body])
        ::MessageBroadcastJob.perform_later(conversation, current_user)
        add_notifications
        current_user.increment_action_count!('message')

        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      rescue StandardError
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
        ::MessagesNotificationsBroadcastJob.perform_later(conversation, current_user)
      end

      def validate_message_limits
        unless current_user.can_perform_action?('message')
          render json: {
            error: "Έχετε φτάσει το όριο των #{UserActionLimit::ACTION_LIMITS['message']}. " \
                    "μηνυμάτων την ημέρα. Αναβαθμίστε για απεριόριστα μηνύματα."
          }, status: :forbidden
        end
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
