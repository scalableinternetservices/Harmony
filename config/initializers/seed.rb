# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if(!User.find_by(id:1))
	Message.delete_all
	Message.connection.execute('ALTER SEQUENCE messages_id_seq RESTART WITH 1')
	User.delete_all
	User.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 1')
	User.create(username: 'guest', firstname: 'guest',password: 'guest', lastname: 'guest', age: 99, gender: 'M', location: 'Goleta')
end