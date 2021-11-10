class MessagesController < ApplicationController
  skip_before_action :require_login, only: [:create, :new, :show]
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

    @current_user = User.find_by(id:@message.user_id) #change when athenication is needed to send a message
    (@channel.users.uniq - @current_user).each do |user|
      Notification.create(recipient: user, actor: @current_user, action: "posted", notifiable: @message)
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
