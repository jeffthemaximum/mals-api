# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  avatar_file :text(65535)
#  avatar_url  :string(255)
#  is_admin    :boolean          default(FALSE)
#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  name        :string(191)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_users_on_latitude_and_longitude  (latitude,longitude)
#  index_users_on_name                    (name) UNIQUE
#

class UserSerializer < ActiveModel::Serializer
  include AuthUtil

  attributes :id, :name, :jwt, :avatar_url, :avatar_file, :created_at, :updated_at
  attributes :jwt

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
