class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user
  skip_before_action :require_login, only: [:seed_page, :seed_with_params, :clear_db]
  skip_before_action :verify_authenticity_token

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
    enable_notif = params.fetch(:notif, false).to_i == 1

    r = Random.new(rnd_seed)

    all_user_list = []
    seed_time = DateTime.now - 3.days
    pwd_digest = User.find_by(id: 1).password_digest
    for uname in 1..num_users
      # user = User.new(username: "u_#{uname}", firstname: generate_string(5, r), password: 'password',
      #                 lastname: generate_string(5, r), age: r.rand(20..80), gender: 'F', location: 'Goleta')
      # user.image.attach(io: File.open("app/assets/images/pp.png"), filename: "pp.png", content_type: "image/png")
      # user.save()
      # if not user.valid?
      #   render plain: "User creation failed"
      # end

      all_user_list << {username: "u_#{uname}", firstname: generate_string(5, r), password_digest: pwd_digest,
                        lastname: generate_string(5, r), age: r.rand(20..80), gender: 'F', location: 'Goleta',
                        created_at: seed_time - 3.days, updated_at: seed_time - 3.days}
    end
    User.insert_all!(all_user_list)
    User.connection.execute("ALTER SEQUENCE users_id_seq RESTART WITH #{all_user_list.length+1}")
    all_channel_list = []
    all_message_list = []
    all_notification_list = []
    tot_msgs = 0
    for cname in 1..num_channels
      rchannel = {id: cname, name: "c_#{cname}", created_at: seed_time - 1.days, updated_at: seed_time - 1.days}
      all_channel_list << rchannel

      num_messages = r.rand(1..(2 * avg_msg_per_channel))
      # use this if you want to enable notification
      # tot_msgs = 0

      all_channel_users = Set[]
      all_channel_messages = []
      for _ in 1..num_messages
        msg_time = seed_time + tot_msgs.seconds
        msg_id = tot_msgs + 1
        ruserid = r.rand(1..(num_users+1))
        all_channel_users.add(ruserid)
        if r.rand() < 0.5
          rmessage = {id: msg_id, content: generate_string(10, r), created_at: msg_time, parent_message_id: nil,
                      updated_at: msg_time + 100.seconds, channel_id: cname, user_id: ruserid}
        else
          rmessage = {id: msg_id, content: generate_string(10, r), created_at: msg_time, parent_message_id: nil,
                      updated_at: msg_time, channel_id: cname, user_id: ruserid}
        end
        all_message_list << rmessage
        all_channel_messages << rmessage

        tot_msgs += 1
        num_replies = r.rand(1..(2 * avg_replies_per_message))
        for _ in 1..num_replies
          ruserid = r.rand(1..(num_users+1))
          all_channel_users.add(ruserid)
          rmessage = {id: tot_msgs+1, content: generate_string(15, r), created_at: msg_time, updated_at: msg_time,
                      parent_message_id: msg_id, channel_id: cname, user_id: ruserid}
          all_message_list << rmessage
          all_channel_messages << rmessage
          tot_msgs += 1
        end
      end

      if not enable_notif
        next
      end
      users_notified = []
      for _ in all_channel_users
        users_notified << r.rand(1..all_channel_messages.length)
      end

      curr_msg_id = 0
      read_at = Time.zone.now
      for rmessage in all_channel_messages
        curr_msg_id += 1
        for ruserid, user_not in all_channel_users.zip(users_notified)
          if ruserid == rmessage[:user_id]
            next
          end
          rnotification = {recipient_id: ruserid, actor_id: rmessage[:user_id], action: "posted",
                           notifiable_id: rchannel[:id], created_at: read_at, updated_at: read_at, read_at: nil}
          if curr_msg_id > user_not
            rnotification[:read_at] = read_at
          end
          all_notification_list << rnotification
        end
      end
    end
    Channel.insert_all!(all_channel_list)
    Message.insert_all!(all_message_list)
    Channel.connection.execute("ALTER SEQUENCE channels_id_seq RESTART WITH #{all_channel_list.length+1}")
    Message.connection.execute("ALTER SEQUENCE messages_id_seq RESTART WITH #{all_message_list.length+1}")

    if all_notification_list.length > 0
      Notification.insert_all!(all_notification_list)
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
    User.create(username: 'guest', firstname: 'guest',password: 'password', lastname: 'guest', age: 99, gender: 'M', location: 'Goleta')
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
