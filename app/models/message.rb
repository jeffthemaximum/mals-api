class Message < ApplicationRecord
  validates :user_id, presence: true
  validates :chat_id, presence: true
  validates :text, :length => { :minimum => 1 }

  belongs_to :chat
  belongs_to :user

  before_save :set_sent_at

  def set_sent_at
    self.sent_at = Time.now
  end
end
