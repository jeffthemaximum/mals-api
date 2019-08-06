# == Schema Information
#
# Table name: chats
#
#  id            :bigint           not null, primary key
#  aasm_state    :string(255)
#  deleted_at    :datetime
#  join_attempts :integer          default(0)
#  latitude      :decimal(10, 6)
#  longitude     :decimal(10, 6)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_chats_on_deleted_at              (deleted_at)
#  index_chats_on_latitude_and_longitude  (latitude,longitude)
#

class ChatSerializer < ActiveModel::Serializer
  attributes :id, :users
  has_many :messages

  def users
    object.users.map do |user|
      ::UserSerializer.new(user, include_jwt: false).attributes
    end
  end
end
