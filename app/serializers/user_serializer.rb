class UserSerializer < ActiveModel::Serializer
  include AuthUtil

  attributes :id, :name, :jwt

  def jwt
    jwt = instance_options[:jwt]
    unless(jwt.present?)
      jwt = get_bearer_token
    end
    return jwt
  end
end
