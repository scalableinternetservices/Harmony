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
    rnd_seed = params[:rnd].to_i

    r = Random.new(rnd_seed)

    for uname in 1..num_users
      user = User.new(username: "u_#{uname}", firstname: generate_string(5, r), password: 'password',
                      lastname: generate_string(5, r), age: r.rand(20..80), gender: 'F', location: 'Goleta')
      user.image.attach(io: File.open("app/assets/images/pp.png"), filename: "pp.png", content_type: "image/png")
      user.save()
      if not user.valid?
        render plain: "User creation failed"
      end
    end
    for cname in 1..num_channels
      channel = Channel.create(name: "c_#{cname}")
      if not channel.valid?
        render plain: "Channel creation failed"
      end
      num_messages = r.rand(1..(2 * avg_msg_per_channel))
      tot_msgs = 0
      for _ in 1..num_messages
        message = channel.messages.build(content: generate_string(10, r), user_id: r.rand(1..(num_users+1)))
	message.save()
        tot_msgs += 1
        if not message.valid?
          render plain: "Message creation failed"
        end
        num_replies = r.rand(1..(2 * avg_replies_per_message))
        for _ in 1..num_replies
          reply = message.replies.build(content: generate_string(15, r), user_id: r.rand(1..(num_users+1)), channel_id: channel.id)
	  reply.save()
          tot_msgs += 1
          if not reply.valid?
            render plain: "Reply creation failed"
          end
        end
      end

      users_notified = []
      all_channel_users = channel.users.uniq
      for user in all_channel_users
        users_notified << r.rand(1..tot_msgs)
      end

      curr_msg_id = 0
      read_at = Time.zone.now
      for message in channel.messages
        curr_msg_id += 1
        for user, user_not in all_channel_users.zip(users_notified)
          if user == message.user
            next
          end
          notification = Notification.new(recipient: user, actor: message.user, action: "posted", notifiable: channel)
          if curr_msg_id > user_not
            notification.read_at = read_at
          end
          notification.save()
        end
        for reply in message.replies
          curr_msg_id += 1
          for user, user_not in all_channel_users.zip(users_notified)
            if user == reply.user
              next
            end
            notification = Notification.new(recipient: user, actor: reply.user, action: "posted", notifiable: channel)
            if curr_msg_id > user_not
              notification.read_at = read_at
            end
            notification.save()
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
    Notification.delete_all
    User.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 1')
    Message.connection.execute('ALTER SEQUENCE messages_id_seq RESTART WITH 1')
    Channel.connection.execute('ALTER SEQUENCE channels_id_seq RESTART WITH 1')
    Notification.connection.execute('ALTER SEQUENCE notifications_id_seq RESTART WITH 1')
    User.create(username: 'guest', firstname: 'guest',password: 'guest', lastname: 'guest', age: 99, gender: 'M', location: 'Goleta')
  end
  
  def ent
    redirect_to "/message/show"
  end

  private

    def generate_string(number, r)
      charset = Array('A'..'Z') + Array('a'..'z')
      Array.new(number) { charset.sample(random: r) }.join
    end

end
