class ChatSerializer < ActiveModel::Serializer
  attributes :id, :users

  def users
    object.users.map do |user|
      ::UserSerializer.new(user, include_jwt: false).attributes
    end
  end
end
