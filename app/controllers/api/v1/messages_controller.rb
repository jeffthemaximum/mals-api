
module Api
  module V1
    class MessagesController < ApiController
      def create
        message = Message.new(create_message_params)
        message.user = @current_user

        chat = Chat.find(create_message_params[:chat_id])

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
        else
          return render json: {errors: message.errors}, status: 422
        end
      end

      def update
        message = Message.find(update_message_params[:id])
        message.update_attributes(update_message_params)
        if message.save
          serialized_data = ActiveModelSerializers::Adapter::Json.new(
            MessageSerializer.new(message)
          ).serializable_hash
          MessagesChannel.broadcast_to message.chat, serialized_data
          head :ok
        else
          return render json: {errors: message.errors}, status: 422
        end
      end

      def index
        if (params[:random] == 'true')
          message = Message.joins(:user).where.not( :users => { :is_admin => true } ).order(Arel.sql('RAND()')).limit(1).first
          return render json: message, serializer: MessageSerializer, status: :ok
        else
          return render json: {errors: ['missing URL param']}, status: 422
        end
      end

      private
        def create_message_params
          params.permit(:chat_id, :client_id, :text)
        end

        def index_messages_params
          params.permit(:random)
        end

        def update_message_params
          params.permit(:delivered_at, :id)
        end
    end
  end
end
