class PostsController < ApplicationController
  attr_accessor :sub_id
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash.now[:notices] = "Thank you for making a post"
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @author = User.find(@post.author_id)
    @current_user_id = (current_user ? current_user.id : nil)
    @sub = Sub.find(@post.sub_id)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(post_params)
      flash.now[:notices] = "Thank you for editing"
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end
end
