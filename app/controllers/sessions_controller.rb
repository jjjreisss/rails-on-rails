class SessionsController < ApplicationController
  def destroy
    @user = User.find_by(session_token: session[:session_token])
    logout(@user)
    redirect_to users_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(
        params[:user][:username],
        params[:user][:password]
    )

    if @user
      login_user!(@user)
      redirect_to user_url(@user)
    else
      flash[:errors] = ["Incorrect username/password!"]
      redirect_to new_session_url
    end
  end
end
