class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user
  skip_before_action :require_login, only: [:seed_page, :seed_with_params, :clear_db]

  def require_login
    redirect_to new_session_path unless session.include? :user_id
  end

  def require_logout
    if session.include? :user_id
      head :forbidden
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_notifications
    @notifications = Notification.where(recipient: @current_user).recent
  end

  # get /seeding
  def seed_page
    render "seeding/index.html.erb"
  end

  # post /seeding
  def seed_with_params
    num_channels = params[:channels].to_i
    avg_msg_per_channel = params[:messages].to_i
    avg_replies_per_message = params[:replies].to_i
    num_users = params[:users].to_i
    for uname in 1..num_users
      user = User.create(username: "u_#{uname}", firstname: generate_string(5), password: 'password',
                         lastname: generate_string(5), age: rand(20..80), gender: 'F', location: 'Goleta')
      if not user.valid?
        render plain: "User creation failed"
      end
    end
    for _ in 1..num_channels
      channel = Channel.create(name: generate_string(10))
      if not channel.valid?
        render plain: "Channel creation failed"
      end
      num_messages = rand(1..(2 * avg_msg_per_channel))
      for _ in 1..num_messages
        message = channel.messages.build(content: generate_string(10), user_id: rand(1..(num_users+1)))
	message.save()
        if not message.valid?
          render plain: "Message creation failed"
        end
        num_replies = rand(1..(2 * avg_replies_per_message))
        for _ in 1..num_replies
          reply = message.replies.build(content: generate_string(15), user_id: rand(1..(num_users+1)), channel_id: channel.id)
	  reply.save()
          if not reply.valid?
            render plain: "Reply creation failed"
          end
        end
      end
    end
  end

  # delete /seeding
  def clear_db
    Message.delete_all
    Channel.delete_all
    User.delete_all
    User.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 1')
    Message.connection.execute('ALTER SEQUENCE messages_id_seq RESTART WITH 1')
    Channel.connection.execute('ALTER SEQUENCE channels_id_seq RESTART WITH 1')
    User.create(username: 'guest', firstname: 'guest',password: 'guest', lastname: 'guest', age: 99, gender: 'M', location: 'Goleta')
  end
  
  def ent
    redirect_to "/message/show"
  end

  private

    def generate_string(number)
      charset = Array('A'..'Z') + Array('a'..'z')
      Array.new(number) { charset.sample }.join
    end

end
