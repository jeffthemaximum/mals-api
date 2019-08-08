module Api
  module V1
    class ChatsController < ApiController
      def join_or_create
        JoinChatService.call(@current_user.id)
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
