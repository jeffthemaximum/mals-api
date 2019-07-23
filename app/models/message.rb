# == Schema Information
#
# Table name: messages
#
#  id           :bigint           not null, primary key
#  delivered_at :datetime
#  sent_at      :datetime
#  text         :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_id      :bigint
#  client_id    :string(255)
#  user_id      :bigint
#
# Indexes
#
#  index_messages_on_chat_id  (chat_id)
#  index_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (user_id => users.id)
#

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
