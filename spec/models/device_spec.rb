# == Schema Information
#
# Table name: devices
#
#  id                 :bigint           not null, primary key
#  brand              :string(255)
#  build_number       :string(255)
#  carrier            :string(255)
#  device             :string(255)
#  device_country     :string(255)
#  device_name        :string(255)
#  fingerprint        :string(255)
#  first_install_time :integer
#  has_accepted_eula  :boolean          default(FALSE)
#  install_referrer   :string(255)
#  manufacturer       :string(255)
#  phone_number       :string(255)
#  readable_version   :string(255)
#  serial_number      :string(255)
#  system_version     :string(255)
#  timezone           :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  build_id           :string(255)
#  bundle_id          :string(255)
#  device_id          :string(255)
#  unique_id          :string(255)
#
# Indexes
#
#  index_devices_on_unique_id  (unique_id)
#

require 'rails_helper'

RSpec.describe Device, type: :model do
  before(:each) do
    @device = build(:device)
    @user1 = build(:user)
    @user2 = build(:user)
    @user3 = build(:user)
  end

  it "cant add the same user twice" do
    @device.users << @user1
    @device.users << @user1
    expect{@device.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "can add two unique users" do
    @device.users << @user1
    @device.users << @user2
    @device.save!
    expect(@device.users.count).to eq(2)
  end
end
