module Api
  module V1
    class ChatsController < ApplicationController
      def join_or_create
        chat = Chat.find_by(aasm_state: Chat.aasm.initial_state)

        if chat.present?
          if chat.includes_user?(@current_user.id)
            chat.destroy!
            chat = Chat.find_by(aasm_state: Chat.aasm.initial_state)
          end
        end

        if (chat)
          chat.users << @current_user
          chat.save!
          chat.start!
        else
          chat = Chat.new
          chat.users << @current_user
          chat.save!
        end

        serialized_data = ActiveModelSerializers::Adapter::Json.new(
          ChatSerializer.new(chat)
        ).serializable_hash

        ActionCable.server.broadcast(
          "current_user_#{@current_user.id}",
          serialized_data
        )

        if (recipient = chat.recipient(@current_user.id))
          ActionCable.server.broadcast(
            "current_user_#{recipient.id}",
            serialized_data
          )
        end

        head :ok
      end
    end
  end
end
