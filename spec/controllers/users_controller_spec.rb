require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST #create" do
    describe "without a name param" do
      it "returns http success" do
        post :create
        expect(response).to have_http_status(:success)
      end

      it "returns serialized user" do
        post :create

        parsed_body = JSON.parse(response.body)
        expect(parsed_body["id"]).should_not be_nil
        expect(parsed_body["name"]).should_not be_nil
        expect(parsed_body["jwt"]).should_not be_nil

        user = User.find(parsed_body["id"])
        serializer = UserSerializer.new(user)
        expect(serializer.to_json).to eq(response.body)
      end
    end

    describe "with a name param" do
      it "returns http success" do
        fake_name = Faker::Name.unique.first_name
        post :create, params: { name: fake_name }
        expect(response).to have_http_status(:success)
      end

      it "returns serialized user" do
        fake_name = Faker::Name.unique.first_name
        post :create, params: { name: fake_name }

        parsed_body = JSON.parse(response.body)
        expect(parsed_body["id"]).should_not be_nil
        expect(parsed_body["name"]).should_not be_nil
        expect(parsed_body["jwt"]).should_not be_nil

        user = User.find(parsed_body["id"])
        serializer = UserSerializer.new(user)
        expect(serializer.to_json).to eq(response.body)
      end

      it "creates user with name param" do
        fake_name = Faker::Name.unique.first_name
        post :create, params: { name: fake_name }

        parsed_body = JSON.parse(response.body)
        expect(parsed_body["name"]).to eq(fake_name)
      end
    end
  end

  describe "PATCH #update" do
    describe "when called without authorization header" do
      it "throws 401" do
        patch :update
        expect(response).to have_http_status(401)
      end
    end

    describe "when called for user that doesnt exist" do
      it "throws 401" do
        user = User.create!
        jwt = user.create_jwt
        user.destroy!

        request.headers.merge!({"Authorization": "Bearer #{jwt}"})
        patch :update
        expect(response).to have_http_status(401)
      end
    end

    describe "when called for valid auth header" do
      before(:each) do
        @user = User.create!
        @jwt = @user.create_jwt
        @different_name = "#{@user.name}#{Faker::Name.unique.first_name}"
      end

      describe "when called with name param" do
        it "returns success response" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          patch :update, params: { name: @different_name }
          expect(response).to have_http_status(:success)
        end

        it "updates user name" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          patch :update, params: { name: @different_name }
          @user.reload

          expect(@user.name).to eq(@different_name)
        end

        it "returns new name value" do
          request.headers.merge!({"Authorization": "Bearer #{@jwt}"})
          patch :update, params: { name: @different_name }
          @user.reload

          parsed_body = JSON.parse(response.body)
          expect(parsed_body["id"]).to eq(@user.id)
          expect(parsed_body["name"]).to eq(@user.name)
          expect(parsed_body["jwt"]).should_not be_nil

          serializer = UserSerializer.new(@user)
          expect(serializer.to_json).to eq(response.body)
        end
      end
    end
  end
end
