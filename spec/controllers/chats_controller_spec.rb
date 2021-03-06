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
    end
  end

  describe "POST #abort" do
    before(:each) do
      @pending_chat = FactoryBot.create(:chat)
      @user_in_pending_chat = @pending_chat.users.first
      @jwt = @user_in_pending_chat.create_jwt
      expect(Chat.where({aasm_state: Chat.aasm.initial_state}).count).to eq(1)
    end

    describe "when called without authorization header" do
      it "throws 401" do
        post :abort, params: { id: @pending_chat.id }
        expect(response).to have_http_status(401)
      end
    end

    describe "with a valid auth header" do
      describe "when requesting chat user doesnt belong to" do
        it "returns 422" do
          other_chat = FactoryBot.create(:chat)
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :abort, params: { id: other_chat.id }
          expect(response).to have_http_status(422)
        end
      end

      describe "when requesting pending chat" do
        it "returns 200" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :abort, params: { id: @pending_chat.id }
          expect(response).to have_http_status(200)
        end

        it "marks chat as finished" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :abort, params: { id: @pending_chat.id }
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
          post :abort, params: { id: @active_chat.id }
          expect(response).to have_http_status(200)
        end

        it "marks chat as finished" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          post :abort, params: { id: @active_chat.id }
          @active_chat.reload
          expect(@active_chat).to have_state(:finished)
        end
      end
    end
  end

  describe "POST #report" do
    before(:each) do
      @chat = FactoryBot.create(:started_chat)
      @user_in_chat = @chat.users.first
      @recipient_in_chat = @chat.users[1]
      expect(@user_in_chat.id).not_to eq(@recipient_in_chat.id)

      @jwt = @user_in_chat.create_jwt
    end

    describe "when user posting with chat_id" do
      it "returns 200" do
        request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
        post :report, params: { id: @chat.id }
        expect(response).to have_http_status(200)
      end

      it "creates new report linked to requesting user" do
        reports = Report.where({ user_id: @user_in_chat.id })
        expect(reports.length).to eq(0)

        request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
        post :report, params: { id: @chat.id }

        reports = Report.where({ user_id: @user_in_chat.id })
        expect(reports.length).to eq(1)
      end

      it "blocks users from eachother" do
        blocks_for_user = @user_in_chat.find_blocks
        expect(blocks_for_user.length).to eq(0)

        blocks_for_recipient = @recipient_in_chat.find_blocks
        expect(blocks_for_recipient.length).to eq(0)

        request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
        post :report, params: { id: @chat.id }

        blocks_for_user = @user_in_chat.find_blocks
        expect(blocks_for_user.length).to eq(1)
        expect(blocks_for_user[0].id).to eq(@recipient_in_chat.id)

        blocks_for_recipient = @recipient_in_chat.find_blocks
        expect(blocks_for_recipient.length).to eq(1)
        expect(blocks_for_recipient[0].id).to eq(@user_in_chat.id)
      end

      it "deletes chat" do
        expect(@chat.deleted?).to eq(false)

        request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
        post :report, params: { id: @chat.id }

        @chat = Chat.with_deleted.find(@chat.id)

        expect(@chat.deleted?).to eq(true)
      end
    end

    describe "when user posting with chat_id and content" do
      it "creates new report with content linked to requesting user" do
        reports = Report.where({ user_id: @user_in_chat.id })
        expect(reports.length).to eq(0)

        content = 'hello plz ban this fool'
        request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
        post :report, params: { id: @chat.id, content: content }

        reports = Report.where({ user_id: @user_in_chat.id })
        expect(reports.length).to eq(1)
        expect(reports[0].content).to eq(content)
      end
    end
  end
end
