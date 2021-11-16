class Message < ApplicationRecord
	belongs_to :channel
	belongs_to :user
	has_many :replies, class_name: 'Message', foreign_key: 'parent_message_id'
	belongs_to :parent_message, class_name: 'Message', optional: true
end

