# == Schema Information
#
# Table name: reports
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_reports_on_chat_id  (chat_id)
#  index_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (user_id => users.id)
#

class Report < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  after_save :block_users_from_eachother
  after_save :delete_chat

  def block_users_from_eachother
    recipient = self.chat.recipient(self.user.id)
    self.user.block!(recipient.id)
  end

  def delete_chat
    self.chat.destroy!
  end
end
