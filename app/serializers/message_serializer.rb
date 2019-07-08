class MessageSerializer < ActiveModel::Serializer
  attributes :id, :chat_id, :text, :user_id, :created_at, :user, :_id, :client_id, :sent_at, :delivered_at

  def user
    { _id: object.user_id, name: object.user.name, avatar_url: object.user.avatar_url, avatar_file: object.user.avatar_file }
  end

  def _id
    object.client_id
  end
end
