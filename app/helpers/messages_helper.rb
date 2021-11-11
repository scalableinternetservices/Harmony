module MessagesHelper
	def channel_path(channel)
		return "channels/#{channel.id}"
	end
end
