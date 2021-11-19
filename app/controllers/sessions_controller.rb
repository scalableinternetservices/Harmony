class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_login, only: [:create, :new]

  
  def index
  end

  
  def create
    session_params = params.permit(:username, :password)
    @user = User.find_by(username: session_params[:username])
    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash[:notice] = "Login is invalid!"
      redirect_to new_session_path
    end
  end


  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been signed out!"
    redirect_to new_session_path
  end

  

  
end
