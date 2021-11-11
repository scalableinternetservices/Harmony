class ChannelsController < ApplicationController
  skip_before_action :require_login, only: [:create, :new, :show, :index]

  # @num_hash = {}
  # for i in Channel.all
  #     @num_hash[i] = i.messages.all.size
  # end
  # puts @num_hash

  def channel_refresh
    @channels = Channel.all
    # @num = Channel.messages.all.size
    render partial: "channel_refresh"
  end

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
