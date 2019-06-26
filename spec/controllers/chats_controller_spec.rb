require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
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

        it "returns a serialized chat" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :join_or_create

          chat = Chat.last
          parsed_body = JSON.parse(response.body)
          expect(parsed_body["id"]).to eq(chat.id)
          expect(parsed_body["users"].length).to eq(1)
          expect(parsed_body["users"][0]["id"]).to eq(@user.id)
          expect(parsed_body["users"][0]["name"]).to eq(@user.name)
          expect(parsed_body["users"][0]["jwt"]).to be_nil

          serializer = ChatSerializer.new(chat)
          expect(serializer.to_json).to eq(response.body)
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

        it "returns a serialized chat" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :join_or_create

          parsed_body = JSON.parse(response.body)

          @chat.reload

          expect(parsed_body["id"]).to eq(@chat.id)
          expect(parsed_body["users"].length).to eq(2)
          expect(parsed_body["users"][0]["id"]).to eq(@user.id)
          expect(parsed_body["users"][0]["name"]).to eq(@user.name)
          expect(parsed_body["users"][0]["jwt"]).to be_nil
          expect(parsed_body["users"][1]["id"]).to eq(@second_user.id)
          expect(parsed_body["users"][1]["name"]).to eq(@second_user.name)
          expect(parsed_body["users"][1]["jwt"]).to be_nil

          serializer = ChatSerializer.new(@chat)
          expect(serializer.to_json).to eq(response.body)
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
