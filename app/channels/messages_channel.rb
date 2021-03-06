class MessagesChannel < ApplicationCable::Channel
  def subscribed
    chat = Chat.find(params[:chat])

    if chat.messages.length == 0
      recipient = chat.recipient(current_user.id)
      distance = chat.distance
      text = "You're chatting with a user who's #{distance} miles away."
      admin_user = User.where({is_admin: true}).first
      message = Message.create!({chat_id: params[:chat], client_id: SecureRandom.uuid, user_id: admin_user.id, text: text})
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        MessageSerializer.new(message)
      ).serializable_hash
      transmit(serialized_data)
    end

    stream_for chat
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
