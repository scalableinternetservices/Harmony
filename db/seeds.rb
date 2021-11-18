def generate_string(number)
  charset = Array('A'..'Z') + Array('a'..'z')
  Array.new(number) { charset.sample }.join
end


if(!User.find_by(id:1))
	Message.delete_all()
	User.delete_all
	User.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 1')
	User.create(username: 'guest', firstname: 'guest',password: 'guest', lastname: 'guest', age: 99, gender: 'M', location: 'Goleta')
end


#following are for load test only
Notification.delete_all()
Notification.connection.execute('ALTER SEQUENCE notifications_id_seq RESTART WITH 1')
Message.delete_all()
Channel.delete_all()
Message.connection.execute('ALTER SEQUENCE messages_id_seq RESTART WITH 1')
Channel.connection.execute('ALTER SEQUENCE channels_id_seq RESTART WITH 1')
#change these two var if you need
#the number too large might need huge number to start up the app
@channelMaxNum = 10
@messageMaxNuminChannel = 30

#these are the generate process
@channelNum = rand(@channelMaxNum)
@i=0
until @i>@channelNum do
	tmp = Channel.new(name:generate_string(5))
	tmp.save()
	@messageNum = rand(@messageMaxNuminChannel)
	@j = 0
	until @j>@messageNum
		tmpMessage = tmp.messages.build(content:generate_string(10),user_id:1)
		tmpMessage.save()
		@j+=1
	end
	@i+=1
end 