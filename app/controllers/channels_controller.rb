class ChannelsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_login, only: [:show, :index]
  
  def index
    @channels = Channel.all
  end

  def show
    @channel = Channel.find(params[:id])
    @users = User.all
  end

  def new
    @channel = Channel.new
  end

  def create
    @channel = Channel.new(channel_params)

    if @channel.save
      redirect_to @channel
    else
      render :new
    end
  end
  private
    def channel_params
      params.require(:channel).permit(:name)
    end

end
