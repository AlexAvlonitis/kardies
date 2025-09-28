module Api
  module V1
    class CommentSerializer < ActiveModel::Serializer
      attributes :body, :user, :created_at

      def created_at
        object.created_at.strftime('%d/%m/%y - %H:%M')
      end

      def user
        UserSerializer.new(object.user, scope: scope, root: false)
      end
    end
  end
end
