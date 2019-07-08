class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  enum notification_type: {
    typing: 0,
    stopped_typing: 1,
    unsubscribe: 2
  }
end
