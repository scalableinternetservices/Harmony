class Channel < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages #this will have users in channel be defined by a user who has posted a message to that channel
  validates :name, presence: true

  def uniq_users
    Rails.cache.fetch(cache_key_with_version, expires_in: 15.seconds) do
      self.users.uniq
    end
  end

  paginates_per 15
end
