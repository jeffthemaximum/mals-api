class UserSerializer < ActiveModel::Serializer
  include AuthUtil

  attributes :id, :name, :jwt, :avatar
  attributes :jwt

  def avatar
    object.avatar_url
  end

  def jwt
    object.create_jwt
  end

  def include_jwt?
    instance_options[:include_jwt] != false
  end

  def attributes(*args)
    hash = super
    if instance_options[:include_jwt] == false
      hash = hash.except(:jwt)
    end
    hash
  end
end
