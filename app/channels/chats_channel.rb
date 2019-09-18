class ChatsChannel < ApplicationCable::Channel
  def subscribed
    #createing a generic channel where all users connect

    # creating a private channel for each user
    stream_from "current_user_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    chat = current_user.chats.last

    unless chat.nil?
      if chat.pending?
        chat.abort!
      elsif chat.active?
        chat.finish!
      end

      notification = Notification.new(chat: chat, notification_type: 'unsubscribe', user: current_user)
      if notification.save
        notification_data = ActiveModelSerializers::Adapter::Json.new(
          NotificationSerializer.new(notification)
        ).serializable_hash
        NotificationsChannel.broadcast_to chat, notification_data
      end
    end
  end
end
