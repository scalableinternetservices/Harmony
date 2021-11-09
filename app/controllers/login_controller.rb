class LoginController < ApplicationController
  skip_before_action :require_login, only: [:create, :new]

  
  def index
  end

  def new
  end

  def create
    login_params = params.permit(:username, :password)
    @user = User.find_by(username: login_params[:username])
    if @user && @user.authenticate(login_params[:password])
      login[:user_id] = @user.id
      redirect_to @user
    else
      flash[:notice] = "Login is invalid!"
      redirect_to new_login_path
    end
  end

  
  def destroy
    login[:user_id] = nil
    flash[:notice] = "You have been signed out!"
    redirect_to new_login_path
  end
  
end
