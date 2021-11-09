class MessagesController < ApplicationController
  def new
    @message = Channel.find_by(id:params[:id]).build
  end

  def show
    if params.has_key?(:id) then
      @channel = Channel.find_by(id:params[:id])
    else
      @channel = Channel.find_by(id:params[:channel_id])
    end
  end

  def create
    @channel = Channel.find_by(id:params[:channel_id])
    @message = @channel.messages.build(message_params)
    @message.user_id=1

    if @message.save
      redirect_to channel_path(@channel)
    end
  end

  def index
    redirect_to '/channels'
  end

  private
    def message_params
      params.require(:message).permit(:content)
    end
end
