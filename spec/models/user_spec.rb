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
