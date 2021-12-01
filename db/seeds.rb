
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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

@channelMaxNum = 3
@messageMaxNuminChannel = 100

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
