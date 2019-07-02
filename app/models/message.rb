class Message < ApplicationRecord
  validates :chat_id, presence: true
  validates :client_id, presence: true, uniqueness: true
  validates :text, :length => { :minimum => 1 }
  validates :user_id, presence: true

  belongs_to :chat
  belongs_to :user

  before_save :set_sent_at

  before_validation :set_client_id

  def set_sent_at
    self.sent_at = Time.now
  end

  def set_client_id
    unless(self.client_id.present?)
      self.client_id = SecureRandom.uuid
    end
  end
end
