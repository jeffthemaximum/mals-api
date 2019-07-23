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

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :chat_id, :text, :user_id, :created_at, :user, :_id, :client_id, :sent_at, :delivered_at

  def user
    { _id: object.user_id, name: object.user.name, avatar_url: object.user.avatar_url, avatar_file: object.user.avatar_file }
  end

  def _id
    object.client_id
  end
end
