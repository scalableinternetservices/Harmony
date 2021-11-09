module MessageHelper
	def channel_path(channel)
		return "/channels/#{channel.id}"
	end
	def get_messages_url(parameters)
		return "/channels/#{parameters[:id]}/messages"
	end
end
