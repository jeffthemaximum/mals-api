class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :user, :notification_type
end
