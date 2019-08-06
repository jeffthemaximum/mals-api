class JoinChatJob < ApplicationJob
  def perform(user, chat)
    JoinChatService.call(user, chat)
  end
end
