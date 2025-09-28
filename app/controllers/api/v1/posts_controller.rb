module Api
  module V1
    class PostsController < ApiController
      def index
        posts = ::Post.shareable.order(created_at: :desc).page(params[:page])

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

      private

      def post_params
        params.require(:post).permit(:body)
      end
    end
  end
end
