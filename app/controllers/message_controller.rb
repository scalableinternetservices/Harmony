class MessageController < ApplicationController
  def post
    @message = Message.new
  end
  def create
    #logger.debug "123456"

    @channel = Channel.find_by(id:params[:channel_id])
    @message = @channel.messages.build(message_params)
    @message.user_id=1
    @message.save
    redirect_to channel_path(@channel)
  end
  def new
    @message = Message.new
  end
  def show
    @channel = Channel.find_by(id:params[:id])
  end
  private

    def message_params
      params.require(:message).permit(:content)
    end
end
