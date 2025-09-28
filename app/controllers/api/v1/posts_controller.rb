module Api
  module V1
    class PostsController < ApiController
      def index
        posts = ::Post.includes(:comments, :votes)
                      .shareable
                      .order(created_at: :desc)
                      .page(params[:page])

        render json: posts, status: :ok
      end

      def create
        post = current_user.posts.build(post_params)

        if post.save
          render json: post, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def create_comment
        post = Post.find(params[:id])
        comment = post.comments.build(comment_params.merge(user: current_user))

        if comment.save
          render json: post, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def like_post
        post = Post.find(params[:id])
        if current_user.voted_for?(post)
          post.unliked_by(current_user)
          render json: post, status: :ok
        else
          post.liked_by(current_user)
          render json: post, status: :ok
        end
      end

      private

      def post_params
        params.require(:post).permit(:body, :wall_shared)
      end

      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
end
