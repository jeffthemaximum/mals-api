module Api
  module V1
    class ChatsController < ApiController
      def join_or_create
        chat = Chat.by_distance(:origin => [@current_user.latitude, @current_user.longitude]).find_by(aasm_state: Chat.aasm.initial_state)

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
          chat.latitude = @current_user.latitude
          chat.longitude = @current_user.longitude
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

          distance = @current_user.distance_to(recipient)
          text = "You're chatting with a user who's #{distance} miles away."
          AdminMessageService.call(chat, text)
        end

        head :ok
      end

      def leave
        # currently unused by mals_app
        chat = Chat.find(leave_params[:id])

        unless chat.includes_user?(@current_user.id)
          errors = ['unauthorized']
          return render json: {errors: errors}, status: 422
        end

        if chat.pending?
          chat.abort!
        elsif chat.active?
          chat.finish!
        end

        head :ok
      end

      private
        def leave_params
          params.permit(:id)
        end
    end
  end
end
