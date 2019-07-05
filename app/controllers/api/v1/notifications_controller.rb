module Api
  module V1
    class NotificationsController < ApiController
      before_action :fetch_chat, :only => [:create]

      def create
        unless @chat.includes_user?(@current_user.id)
          errors = ['unauthorized']
          return render json: {errors: errors}, status: 422
        end

        notification = Notification.new(create_params)
        notification.user = @current_user

        if notification.save
          notification_data = ActiveModelSerializers::Adapter::Json.new(
            NotificationSerializer.new(notification)
          ).serializable_hash
          NotificationsChannel.broadcast_to notification.chat, notification_data
          head :ok
        else
          return render json: {errors: notification.errors}, status: 422
        end
      end

      private
        def create_params
          params.permit(:chat_id, :notification_type, :user_id)
        end

        def fetch_chat
          @chat = Chat.find create_params[:chat_id]
        end
    end
  end
end
