require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do
  describe "GET index" do
    describe "when called without authorization header" do
      it "throws 401" do
        get :index
        expect(response).to have_http_status(401)
      end
    end

    describe "with a valid authorization header" do
      before(:each) do
        @user = FactoryBot.create(:user)
        @jwt = @user.create_jwt
        @message = FactoryBot.create(:message)
      end

      describe "when messages exist" do
        it "returns 200" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          get :index, params: { random: 'true' }
          expect(response).to have_http_status(:success)
        end

        it "returns the one message in DB" do
          expect(Message.count).to eq(1)

          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          get :index, params: { random: 'true' }

          parsed_body = JSON.parse(response.body)
          expect(parsed_body["id"]).should_not be_nil
          expect(parsed_body["text"]).should_not be_nil
          expect(parsed_body["user"]["avatar_file"]).should_not be_nil
        end
      end
    end
  end
end
