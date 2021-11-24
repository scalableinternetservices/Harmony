class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :show]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_logout, only: [:new, :create]
  before_action :check_user, only: [:edit, :update, :destroy]



  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find_by(id: params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.create(user_params)

    if @user.valid?
      session[:user_id] = @user.id
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :firstname, :lastname, :age, :gender, :location, :image)
      # params.fetch(:user, {})
    end

    def check_user
      if session[:user_id] != @user.id
        head :forbidden
      end
    end
end
