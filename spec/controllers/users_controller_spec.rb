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

end
