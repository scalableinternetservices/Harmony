class MessagesController < ApplicationController
  skip_before_action :require_login, only: [:create, :new, :show]
  layout false
  caches_action :ajaxRender
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
    if params.has_key?(:channel_id) then
      @channel = Channel.find_by(id:params[:channel_id])
      if(params[:id]=="history")
        history
      end
    else
      @channel = Channel.find_by(id:params[:id])
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
      # Create notifications
      # can add some sort of (@channel.users.uniq - [current_user]).each do |user| so the user posting doesnt get the notification
      (@channel.users.uniq - [current_user]).each  do |user|
        Notification.create(recipient: user, actor: current_user, action: "posted", notifiable: @channel)
      end
    else
      @message.user_id=1 #by default there is a guest account in user which id=1
    end

    # add notification for reply 
    # if(@message.parent_message != Nil)
    #   @parrent_user = User.find_by(id: @message.parent_message.id)
    #   Notification.create(recipient: @parrent_user, actor: current_user, action: "replied", notifiable: @channel)
    # end
    if @message.save
      redirect_to channel_path(@channel)
    end
  end

  def index
    redirect_to '/channels'
  end

  def ajaxRender
    format.html { render :action=>"show"} 
  end

  def history
    @channel = Channel.find_by(id:params[:channel_id])
    messageBuffer=[]
    @channel.messages.limit(20).offset(params[:ReverseId]).reverse.each do |message|
      item = {:id => messsage.id,:user_id => message.user_id,:repiles=>message.replies, :content=>message.content,
        :created_at=>message.created_at,:parent_message => messsage.parent_message_id}
      messageBuffer << item
    end
    render json: {success:true, data: messageBuffer}
  end

  private
    def message_params
      params.require(:message).permit(:content, :parent_message_id, :user_id, :channel_id)
    end
end
