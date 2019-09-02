# == Schema Information
#
# Table name: devices_users
#
#  device_id :bigint           not null
#  user_id   :bigint           not null
#
# Indexes
#
#  index_devices_users_on_user_id_and_device_id  (user_id,device_id)
#

class DevicesUser < ApplicationRecord
  belongs_to :user
  belongs_to :device

  validates :user_id, :uniqueness => { :scope => :device_id }
end
