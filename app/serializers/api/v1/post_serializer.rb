module Api
  module V1
    class PostSerializer < ActiveModel::Serializer
      belongs_to :user
      has_many   :comments, serializer: CommentSerializer

      attributes :id, :body, :wall_shared, :created_at, :likes_count, :likes,
                 :liked

      def created_at
        object.created_at.strftime('%d/%m/%y - %H:%M')
      end

      def likes_count
        object.get_likes.size
      end

      def likes
        object.get_likes.map do |like|
          {
            id: like.voter.id,
            username: like.voter.username,
          }
        end
      end

      def liked
        scope && scope.voted_for?(object)
      end
    end
  end
end
