# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  avatar_file :text(65535)
#  avatar_url  :string(255)
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

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new(name: 'jeff')
  end

  context "creating a valid new user" do
    it "should be valid" do
      expect(@user.valid?).to eq(true)
    end
  end

  context "when missing name" do
    it "should set name" do
      blank_name = "    "
      @user.name = blank_name
      expect(@user.valid?).to eq(true)
      expect(@user.name).not_to eq(blank_name)
      expect(@user.name.present?).to eq(true)
      expect(@user.save).to eq(true)
    end
  end

  context "when creating duplicate user" do
    it "should be invalid" do
      dupe_user = @user.dup
      @user.save
      dupe_user.name = @user.name.upcase
      expect(dupe_user.valid?).to eq(false)
    end
  end
end
