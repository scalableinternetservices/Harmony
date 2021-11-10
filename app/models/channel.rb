class Channel < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users#, through :messages #this will have users in channel be defined by a user who has posted a message to that channel
  validates :name, presence: true
end
