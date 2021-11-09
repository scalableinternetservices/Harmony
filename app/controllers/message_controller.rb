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
    if params.has_key?(:id) then
      @channel = Channel.find_by(id:params[:id])
    else
      @channel = Channel.find_by(id:params[:channel_id])
    end
  end

  # PATCH/PUT /message/1
  def update
    @message = Message.find_by(id: params[:id])
    if @message.update(message_params)
      redirect_to channel_path(@message.channel), notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end
  
  private

    def message_params
      params.require(:message).permit(:content)
    end
end
