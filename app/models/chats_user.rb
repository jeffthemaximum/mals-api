# == Schema Information
#
# Table name: chats_users
#
#  chat_id :bigint           not null
#  user_id :bigint           not null
#
# Indexes
#
#  index_chats_users_on_user_id_and_chat_id  (user_id,chat_id)
#

class ChatsUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :user_id, :uniqueness => { :scope => :chat_id }
end
