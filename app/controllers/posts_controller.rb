class PostsController < ApplicationController

  def new
    @post  = current_user.posts.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:notice] = "Post has been saved"
      redirect_to root_path
    else
      flash[:notice] = "Post has not been saved"
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
