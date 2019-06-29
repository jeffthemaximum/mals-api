class Message < ApplicationRecord
  validates :user_id, presence: true
  validates :chat_id, presence: true
  validates :text, :length => { :minimum => 1 }

  belongs_to :chat
  belongs_to :user
end
