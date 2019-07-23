# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  notification_type :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  chat_id           :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_notifications_on_chat_id            (chat_id)
#  index_notifications_on_notification_type  (notification_type)
#  index_notifications_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (user_id => users.id)
#

class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :user, :notification_type
end
