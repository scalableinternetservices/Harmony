class Channel < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users #, through: :messages 
  #this will set users of a channel to those who have sent a message to that channel
  validates :name, presence: true
end
