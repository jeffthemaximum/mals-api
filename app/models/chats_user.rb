class ChatsUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :user_id, :uniqueness => { :scope => :chat_id }

  validate :max_user_count

  def max_user_count
    chat_id = self.chat_id
    unless Chat.find(chat_id).users.count < 2
      errors.add(:base, 'Too many users')
    end
  end
end
