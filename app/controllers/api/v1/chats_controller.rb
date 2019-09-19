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

      def report
        begin
          chat = Chat.find(report_params[:id])
        rescue ActiveRecord::RecordNotFound => e
          StatService.instance.enqueue('ChatsController.report.chat_not_found', { count: 1 })
          return render json: {}, status: :ok
        end

        unless chat.includes_user?(@current_user.id)
          errors = ['unauthorized']
          return render json: {errors: errors}, status: 422
        end

        report = Report.new(chat_id: chat.id, content: report_params[:content], user_id: @current_user.id)

        unless(report.save)
          return render json: {errors: user.errors}, status: 422
        end

        render json: report, serializer: ReportSerializer, status: :ok
      end

      private
        def leave_params
          params.permit(:id)
        end

        def report_params
          params.permit(:id, :content)
        end
    end
  end
end
