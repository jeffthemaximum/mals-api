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

  describe "POST #leave" do
    before(:each) do
      @pending_chat = FactoryBot.create(:chat)
      @user_in_pending_chat = @pending_chat.users.first
      @jwt = @user_in_pending_chat.create_jwt
      expect(Chat.where({aasm_state: Chat.aasm.initial_state}).count).to eq(1)
    end

    describe "when called without authorization header" do
      it "throws 401" do
        post :leave, params: { id: @pending_chat.id }
        expect(response).to have_http_status(401)
      end
    end

    describe "with a valid auth header" do
      describe "when requesting user requesting non existant chat" do
        it "returns 404" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :leave, params: { id: @pending_chat.id + 1 }
          expect(response).to have_http_status(404)
        end
      end

      describe "when requesting chat user doesnt belong to" do
        it "returns 422" do
          other_chat = FactoryBot.create(:chat)
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :leave, params: { id: other_chat.id }
          expect(response).to have_http_status(422)
        end
      end

      describe "when requesting pending chat" do
        it "returns 200" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :leave, params: { id: @pending_chat.id }
          expect(response).to have_http_status(200)
        end

        it "marks chat as finished" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :leave, params: { id: @pending_chat.id }
          @pending_chat.reload
          expect(@pending_chat).to have_state(:finished)
        end
      end

      describe "when requesting active chat" do
        before(:each) do
          @other_user = FactoryBot.create(:user)
          @pending_chat.users << @other_user
          @pending_chat.start!
          @active_chat = @pending_chat
          expect(@active_chat).to have_state(:active)
        end

        it "returns 200" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :leave, params: { id: @active_chat.id }
          expect(response).to have_http_status(200)
        end

        it "marks chat as finished" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :leave, params: { id: @active_chat.id }
          @active_chat.reload
          expect(@active_chat).to have_state(:finished)
        end
      end
    end
  end
end
