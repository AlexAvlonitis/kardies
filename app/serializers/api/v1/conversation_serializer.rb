module Api
  module V1
    class ConversationSerializer < ActiveModel::Serializer
      has_many :participants

      attributes :id

      def participants
        object.participants.reject { |user| scope == user }.first
      end
    end
  end
end
