class UserSerializer < ActiveModel::Serializer
  include AuthUtil

  attributes :id, :name, :jwt

  def jwt
    object.create_jwt
  end
end
