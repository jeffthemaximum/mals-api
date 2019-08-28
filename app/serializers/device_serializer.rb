class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :brand, :build_id, :build_number, :bundle_id, :carrier, :device, :device_country, :device_id, :device_name, :fingerprint, :first_install_time, :install_referrer, :manufacturer, :phone_number, :readable_version, :serial_number, :system_version, :timezone, :unique_id
end
