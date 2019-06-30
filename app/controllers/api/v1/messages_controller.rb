
module Api
  module V1
    class MessagesController < ApiController
      def create
        message = Message.new(message_params)
        chat = Chat.find(message_params[:chat_id])

        unless chat.includes_user?(@current_user.id)
          errors = ['unauthorized']
          return render json: {errors: errors}, status: 422
        end

        if message.save
          serialized_data = ActiveModelSerializers::Adapter::Json.new(
            MessageSerializer.new(message)
          ).serializable_hash
          MessagesChannel.broadcast_to chat, serialized_data
          head :ok
        end
      end

      private

      def message_params
        params.permit(:chat_id, :client_id, :text, :user_id)
      end
    end
  end
end
