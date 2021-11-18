json.array! @notifications do |notification|
    json.id notification.id
    # json.recipient notification.recipient
    # json.recipient do
    #     json.username notification.recipient.username
    # end
    
    # json.actor notification.actor
    # json.actor do
    #     json.username notification.actor.username
    # end 

    json.actor notification.actor.username

    json.action notification.action
    # json.notifiable do
    #     json.type "a #{notification.notifiable.class.to_s.underscore.humanize.downcase}"
    # end

    json.notifiable notification.notifiable

    json.url channel_id_path(notification.notifiable.id)
    json.read notification.read_at

end 