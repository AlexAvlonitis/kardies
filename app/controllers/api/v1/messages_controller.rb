module Api
  module V1
    class MessagesController < ApiController
      skip_before_action :verify_authenticity_token, only: :create
      after_action :add_conversation_notification, :conversation_notification_email

      def create
        @recipient ||= User.find_by(username: params[:message][:username])
        if @recipient == current_user
          render json: { error: 'δεν μπορείτε να στείλετε μήνυμα στον εαυτό σας' }, status: :forbidden
          return
        end
        if UserBlockedCheck.call(current_user, @recipient)
          return block_and_render('Ο χρήστης σας έχει μπλοκάρει')
        end
        send_message
      end

      private

      def send_message
        conversation = find_existing_conversation
        if conversation && !conversation_deleted?(conversation)
          current_user.reply_to_conversation(conversation, params[:message][:body])
        else
          conversation = current_user.send_message(
            @recipient,
            params[:message][:body],
            current_user.username
          ).conversation
        end
        render json: { data: 'μήνυμα εστάλει' }, status: :ok
      end

      def add_conversation_notification
        ConversationNotification.create(user_id: @recipient.id,
                                        receiver_id: current_user.id,
                                        received: true)
      end

      def conversation_notification_email
        @conversation_notification_email ||=
          ConversationsNotificationEmail.new(@recipient).send_email
      end

      def find_existing_conversation
        Mailboxer::Conversation
          .between(current_user, @recipient)
          .find { |c| c.participants.count == 2 }
      end

      def conversation_deleted?(conversation)
        conversation.is_deleted?(current_user) ||
          conversation.is_deleted?(@recipient)
      end
    end
  end
end
