module Api
  module V1
    class ChatsController < ApiController
      before_action :fetch_chat, :only => [:abort, :block, :report]

      def abort
        if @chat.pending?
          @chat.abort!
        elsif @chat.active?
          @chat.finish!
        end

        head :ok
      end

      def block
        # "block" is probably not the best name but here we are
        # this endpoint is for deleting a chat
        # it's used by app when a user leaves a random chat and choses to not save the chat
        @chat.destroy!
        head :ok
      end

      def index
        chats = @current_user
          .chats
          .joins(:users)
          .where.not( :users => { :id => not_ids } )
          .where.not(aasm_state: Chat.aasm.initial_state)
          .includes(:messages)
          .order('messages.created_at DESC')

        chats = chats.select { |chat| chat.users.count == 2 }

        render json: chats, each_serializer: ChatSerializer, status: :ok
      end

      def join_or_create
        current_user_name = @current_user.name
        message = "Get on chat, Jeff, #{current_user_name} is trying to chat!"
        SendTextService.call(message, Rails.application.credentials.my_phone_number)
        JoinChatService.call(@current_user.id)
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

        def not_ids
          @current_user.find_blocks.map{ |user| user.id }
        end
    end
  end
end
