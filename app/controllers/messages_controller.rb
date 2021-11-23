class MessagesController < ApplicationController
  skip_before_action :require_login, only: [:create, :new, :show]
  def new
    @message = Channel.find_by(id:params[:id]).build
  end
  def update
    @message = Message.find_by(id: params[:id])
    if @message.update(message_params)
      redirect_to channel_path(@message.channel), notice: 'Message was successfully updated.'
    else
      render :edit
    end
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
  
  def create
    @channel = Channel.find_by(id:params[:channel_id])
    @message = @channel.messages.build(message_params)
    if(session[:user_id])
      @message.user_id = session[:user_id]
    else
      @message.user_id=1 #by default there is a guest account in user which id=1
    end
    if @message.save
      redirect_to channel_path(@channel)
    end
  end

  def index
    redirect_to '/channels'
  end

  private
    def message_params
      params.require(:message).permit(:content, :parent_message_id, :user_id, :channel_id)
    end
end
