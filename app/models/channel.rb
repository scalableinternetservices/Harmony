class Channel < ApplicationRecord
  has_many :messages, dependent: :destroy
<<<<<<< HEAD
  has_many :users#, through :messages #this will have users in channel be defined by a user who has posted a message to that channel
=======
  has_many :users #, through: :messages 
  #this will set users of a channel to those who have sent a message to that channel
>>>>>>> 97356d5d018d90b4b017880414f29e879eefdb5c
  validates :name, presence: true
end
