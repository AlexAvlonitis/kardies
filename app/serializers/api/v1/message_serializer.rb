module Api
  module V1
    class MessageSerializer < ActiveModel::Serializer
      belongs_to :sender

      attributes :id, :body, :created_at

      def created_at
        object.created_at.strftime('%d/%m/%y | %H:%M')
      end
    end
  end
end
