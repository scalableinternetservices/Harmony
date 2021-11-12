class MessagesController < ApplicationController
  # before_action :require_login
  skip_before_action :require_login, only: [:create, :new, :show]

  def new
    @message = Channel.find_by(id:params[:id]).build
  end

  def show
    if params.has_key?(:id) then
      @channel = Channel.find_by(id:params[:id])
      render 'app/views/notifications/index.json.jbuilder'
    else
      @channel = Channel.find_by(id:params[:channel_id])
    end
  end

  def create
    @channel = Channel.find_by(id:params[:channel_id])
    @message = @channel.messages.build(message_params)
    #want to change user_id to username
    @message.user_id=current_user.id

    # Create notifications
    # can add some sort of (@forum_thread.users.uniq - [current_user]).each do |user| so the user posting doesnt get the notification
    # currently getting error can't convert User to Array when i try tho
    @channel.users.uniq.each do |user|
      Notification.create(recipient: user, actor: current_user, action: "posted", notifiable: @channel)
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
      params.require(:message).permit(:content)
    end
end
