class SubsController < ApplicationController
  before_action :ensure_proper_user, only: [:edit, :update]

  def index
    @subs = Sub.all
    @current_user_id = (current_user ? current_user.id : nil)
  end

  def new
    @sub = Sub.new
  end

  def create
    @sub = current_user.subs.new(sub_params)
    if @sub.save
      flash.now[:notices] = "Thank you for making a sub"
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def show
    @sub = Sub.find(params[:id])
    @author = User.find(@sub.author_id)
  end

  def edit
  end

  def update
    if @sub.update_attributes(sub_params)
      flash.now[:notices] = "Thank you for editing"
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def ensure_proper_user
    @sub = current_user.subs.find(params[:id])
    unless @sub
      flash[:errors] = ["Can't edit other people's subs you jerk!"]
      redirect_to subs_url
    end
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :description)
  end

end
