class MessagesController < ApplicationController
  skip_before_action :require_login, only: [:create, :new, :show]
  layout false
  caches_action :ajaxRender
  def new
    @message = Channel.find_by(id:params[:id]).build
  end

  def show
    if params.has_key?(:channel_id) then
      @channel = Channel.find_by(id:params[:channel_id])
      if(params[:id]=="history")
        history
      elsif(params[:id]=="newMessage")
        newMessage
      elsif(params[:id]=="modifiedMessage")
        modifiedMessage
      end
    else
      @channel = Channel.find_by(id:params[:id])
    end
  end

  # PATCH/PUT /message/1
  def update
    @message = Message.find_by(id: params[:id])
    if @message.update(message_params)
      head :created
      #redirect_to channel_path(@message.channel), notice: 'Message was successfully updated.'
    else
      head :bad_request
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
      head :created
    else
      head :bad_request
    end
  end

  def index
    redirect_to '/channels'
  end

  #This check if messages in history has been edited
  def modifiedMessage
    modifiedBuffer=[]
    @channel = Channel.find_by(id:params[:channel_id])
    @channel.messages.offset(params[:minId]).where("updated_at>?",params[:lastUpdated].to_time).each do |message|
      item = {:content=>message.content,:id=>message.id}
      modifiedBuffer <<item
    end
    render json: {data: modifiedBuffer}
  end

  #type 0 is parent, 1 is children(reply), int compare always faster than string
  def newMessage
    @channel = Channel.find_by(id:params[:channel_id])
    messageBuffer=[]
    @channel.messages.where("id>?",params[:lastId]).each do |message|
      if message.parent_message_id then
        item = {:id => message.id,:username=>message.user.username,:content=>message.content,
          :created_at=>message.created_at,:parentId=>message.parent_message_id,:type=>1}
        messageBuffer << item
      else
        item = {:id => message.id,:username=>message.user.username,:content=>message.content,
          :created_at=>message.created_at,:type=>0}
        messageBuffer << item
      end
    end
    render json: {success:true,channelId:params[:channel_id],data: messageBuffer,token:form_authenticity_token}
  end
  #type 0 is parent, 1 is children(reply), int compare always faster than string

  def history
    @channel = Channel.find_by(id:params[:channel_id])
    messageBuffer=[]
    @channel.messages.where(parent_message_id:nil).order('id DESC').limit(10).offset(params[:parentMessageCount]).each do |message|
      item = {:id => message.id,:username=>message.user.username,:content=>message.content,
        :created_at=>message.created_at,:type=>0}
      messageBuffer << item
      message.replies.each do |reply|
        item = {:id => reply.id,:username=>reply.user.username,:content=>reply.content,
        :created_at=>reply.created_at,:type=>1}
        messageBuffer << item
      end
    end
    render json: {success:true,channelId:params[:channel_id],data: messageBuffer,token:form_authenticity_token}
  end

  private
    def message_params
      params.require(:message).permit(:content, :parent_message_id, :user_id, :channel_id)
    end
end
