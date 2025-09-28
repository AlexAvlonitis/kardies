module Api
  module V1
    class PostSerializer < ActiveModel::Serializer
      belongs_to :user
      has_many   :comments, serializer: CommentSerializer

      attributes :id, :body, :wall_shared, :created_at

      def created_at
        object.created_at.strftime('%d/%m/%y - %H:%M')
      end
    end
  end
end
