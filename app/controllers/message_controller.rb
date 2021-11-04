class MessageController < ApplicationController
  def post
    @message = Message.new
  end
  def create
    @message = Message.new(message_params)
    @message.save
    redirect_to "/"
  end
  def new
    @message = Message.new
  end
  def show
  end
  private

    def message_params
      params.require(:message).permit(:content)
    end
end
