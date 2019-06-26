class ChatsController < ApplicationController
  def join_or_create
    chat = Chat.find_by(aasm_state: Chat.aasm.initial_state)

    if (chat)
      chat.users << @current_user
      chat.save!
      chat.start!
    else
      chat = Chat.new
      chat.users << @current_user
      chat.save!
    end

    # return serialized chat
    render json: chat, serializer: ChatSerializer, status: :ok
  end
end
