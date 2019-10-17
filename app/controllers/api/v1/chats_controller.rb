module Api
  module V1
    class ChatsController < ApiController
      before_action :fetch_chat, :only => [:abort, :report]

      def join_or_create
        message = 'Get on chat, Jeff, someone is trying to chat!'
        SendTextService.call(message, Rails.application.credentials.my_phone_number)
        JoinChatService.call(@current_user.id)
        head :ok
      end

      def abort
        if @chat.pending?
          @chat.abort!
        elsif @chat.active?
          @chat.finish!
        end

        head :ok
      end

      def report
        report = Report.new(chat_id: @chat.id, content: report_params[:content], user_id: @current_user.id)

        unless(report.save)
          return render json: {errors: user.errors}, status: 422
        end

        render json: report, serializer: ReportSerializer, status: :ok
      end

      private
        def fetch_chat
          begin
            @chat = Chat.find(params[:id])
          rescue ActiveRecord::RecordNotFound => e
            StatService.instance.enqueue('ChatsController.chat_not_found', { count: 1 })
            errors = ['Invalid chat_id']
            return render json: {errors: errors}, status: 422
          end

          unless @chat.includes_user?(@current_user.id)
            errors = ['unauthorized']
            return render json: {errors: errors}, status: 422
          end
        end

        def abort_params
          params.permit(:id)
        end

        def report_params
          params.permit(:id, :content)
        end
    end
  end
end
