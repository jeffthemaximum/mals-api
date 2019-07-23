class AdminMessageService < ApplicationService
  def initialize(chat, text)
    @admin_user = User.where({is_admin: true}).first
    @chat = chat
    @text = text
  end

  def call
    message = Message.create!({chat_id: @chat.id, client_id: SecureRandom.uuid, user_id: @admin_user.id, text: @text})
    serialized_data = ActiveModelSerializers::Adapter::Json.new(
      MessageSerializer.new(message)
    ).serializable_hash
    MessagesChannel.broadcast_to message.chat, serialized_data
  end
end
