# == Schema Information
#
# Table name: chats
#
#  id            :bigint           not null, primary key
#  aasm_state    :string(255)
#  deleted_at    :datetime
#  join_attempts :integer          default(0)
#  latitude      :decimal(10, 6)
#  longitude     :decimal(10, 6)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_chats_on_deleted_at              (deleted_at)
#  index_chats_on_latitude_and_longitude  (latitude,longitude)
#

require 'rails_helper'

RSpec.describe Chat, type: :model do
  before(:each) do
    @chat = Chat.new
    @user1 = User.create!
    @user2 = User.create!
    @user3 = User.create!
  end

  describe "user association" do
    it "needs at least one user" do
      expect{@chat.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "cant add the same user twice" do
      @chat.users << @user1
      @chat.users << @user1
      expect{@chat.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "cant add more than 2 users" do
      @chat.users << @user1
      @chat.users << @user2
      @chat.users << @user3
      expect{@chat.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "can add two unique users" do
      @chat.users << @user1
      @chat.users << @user2
      @chat.save!
      expect(@chat.users.count).to eq(2)
    end
  end

  describe "aasm" do
    describe "initial state" do
      it "should equal 'pending'" do
        expect(@chat).to have_state(:pending)
      end

      describe "with 0 associated users" do
        it "shouldnt transition to 'active'" do
          expect(@chat.users.count).to eq(0)
          expect(@chat).not_to allow_transition_to(:active)
        end
      end

      describe "with 1 associated user" do
        it "shouldnt transition to 'active'" do
          @chat.users << @user1
          @chat.save!
          expect(@chat.users.count).to eq(1)
          expect(@chat).not_to allow_transition_to(:active)
        end
      end

      describe "with 2 associated users" do
        it "should allow transition to 'active'" do
          @chat.users << @user1
          @chat.users << @user2
          @chat.save!
          expect(@chat.users.count).to eq(2)
          expect(@chat).to allow_transition_to(:active)
        end
      end
    end
  end
end
