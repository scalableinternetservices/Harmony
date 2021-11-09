class MessageController < ApplicationController
  skip_before_action :require_login, only: [:create, :new, :show]

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
    if params.has_key?(:id) then
      @channel = Channel.find_by(id:params[:id])
    else
      @channel = Channel.find_by(id:params[:channel_id])
    end
  end
  private

    def message_params
      params.require(:message).permit(:content)
    end
end
