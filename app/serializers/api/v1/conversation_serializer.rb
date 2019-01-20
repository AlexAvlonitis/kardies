module Api
  module V1
    class ConversationSerializer < ActiveModel::Serializer
      has_many :participants

      attributes :id, :is_read

      def is_read
        object.is_read? current_user
      end

      def participants
        return unless object.participants.count > 1
        object.participants.reject { |user| scope == user }.first
      end
    end
  end
end
