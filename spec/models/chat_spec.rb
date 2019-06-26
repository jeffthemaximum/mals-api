require 'rails_helper'

RSpec.describe Chat, type: :model do
  before(:each) do
    @chat = Chat.create!
    @user1 = User.create!
    @user2 = User.create!
    @user3 = User.create!
  end

  describe "user association" do
    it "cant add the same user twice" do
      @chat.users << @user1
      expect{@chat.users << @user1}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@chat.users.count).to eq(1)
    end

    it "cant add more than 2 users" do
      @chat.users << @user1
      @chat.users << @user2
      expect{@chat.users << @user3}.to raise_error(ActiveRecord::RecordInvalid)
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
          expect(@chat.users.count).to eq(1)
          expect(@chat).not_to allow_transition_to(:active)
        end
      end

      describe "with 2 associated users" do
        it "should allow transition to 'active'" do
          @chat.users << @user1
          @chat.users << @user2
          expect(@chat.users.count).to eq(2)
          expect(@chat).to allow_transition_to(:active)
        end
      end
    end
  end
end
