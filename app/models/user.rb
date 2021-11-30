class User < ApplicationRecord
  has_secure_password
  
  has_many :messages, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id
  has_one_attached :image, dependent: :destroy
  validates :image, content_type: [:png, :jpg, :jpeg]
  validates :username, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :age, presence: true
  validates :age, numericality: { greater_than: 18, less_than_or_equal_to: 100 }

end
