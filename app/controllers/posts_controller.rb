class PostsController < ApplicationController

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:notice] = "Post has been saved"
      redirect_to root_path
    else
      flash[:notice] = "Post has not been saved"
      redirect_to root_path
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
