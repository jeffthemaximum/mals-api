class MessageSerializer < ActiveModel::Serializer
  attributes :id, :chat_id, :text, :user_id, :created_at, :user, :_id, :client_id, :sent_at

  def user
    { _id: object.user_id, name: object.user.name, avatar: object.user.avatar_url }
  end

  def _id
    object.client_id
  end
end
