json.array! @notifications do |notification|
    json.recipient notification.recipient
    json.actor notification.actor
    json.action notification.action
    json.notifiable do
        json.type "a #{notification.notifiable.class.to_s.underscore.humanize.downcase}"
    end

    json.url channel_path(notification.notifiable.channel, anchor: dom_id(notification.notifiable))
end 