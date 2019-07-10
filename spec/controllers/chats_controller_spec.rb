require 'rails_helper'

RSpec.describe Api::V1::ChatsController, type: :controller do
  describe "POST #join_or_create" do
    describe "when called without authorization header" do
      it "throws 401" do
        post :join_or_create
        expect(response).to have_http_status(401)
      end
    end

    describe "with a valid authorization header" do
      before(:each) do
        @user = User.create!
        @jwt = @user.create_jwt
        expect(Chat.where({aasm_state: Chat.aasm.initial_state}).count).to eq(0)
      end

      describe "when no pending chats exist" do
        it "returns 200" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :join_or_create
          expect(response).to have_http_status(:success)
        end

        it "creates a chat" do
          chat_count = Chat.count
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :join_or_create
          expect(Chat.count).to eq(chat_count + 1)
        end

        it "creates a pending chat" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :join_or_create

          chat = Chat.last
          expect(chat).to have_state(:pending)
        end
      end

      describe "when pending chat exists" do
        before(:each) do
          @user = User.create!
          @chat = Chat.new
          @chat.users << @user
          @chat.save!
          expect(Chat.where({aasm_state: Chat.aasm.initial_state}).count).to eq(1)

          @second_user = User.create!
          @jwt = @second_user.create_jwt
        end

        it "returns 200" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :join_or_create
          expect(response).to have_http_status(:success)
        end

        it "doesnt create a chat" do
          chat_count = Chat.count
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :join_or_create
          expect(Chat.count).to eq(chat_count)
        end

        it "starts the chat" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :join_or_create

          @chat.reload

          expect(@chat).to have_state(:active)
        end
      end
    end
  end
end
