module MessagesHelper
	def channel_path(channel)
		return "channels/#{channel.id}"
	end

	def channel_id_path(id)
		return "channels/#{id}"
	end
end
