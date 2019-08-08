class JoinChatJob < ApplicationJob
  def perform(user_id, chat_id)
    JoinChatService.call(user_id, chat_id)
  end
end
