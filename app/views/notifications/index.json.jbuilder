json.array! @notifications do |notification|
    json.id notification.id
    json.actor notification.actor.username
    json.unread !notification.read_at?

    # json.action notification.action
    # json.notifiable do
    #     json.type "a #{notification.notifiable.class.to_s.underscore.humanize.downcase}"
    # end

    # json.notifiable notification.notifiable

    # json.url channel_id_path(notification.notifiable.id)
    # json.read notification.read_at

    json.template render partial: "notifications/message", locals: {notification: notification}, formats: [:html]
end 