class MessagesChannel < ApplicationCable::Channel
  include ActionView::Helpers::NumberHelper

  def subscribed
    chat = Chat.find(params[:chat])

    recipient = chat.recipient(current_user.id)
    distance = number_with_precision(current_user.distance_to(recipient), :precision => 3)
    text = "You're chatting with a user who's #{distance} miles away."
    admin_user = User.where({is_admin: true}).first
    message = Message.create!({chat_id: params[:chat], client_id: SecureRandom.uuid, user_id: admin_user.id, text: text})
    serialized_data = ActiveModelSerializers::Adapter::Json.new(
      MessageSerializer.new(message)
    ).serializable_hash
    transmit(serialized_data)

    stream_for chat
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
