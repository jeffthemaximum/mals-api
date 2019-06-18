require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #get_or_create" do
    it "returns http success" do
      get :get_or_create
      expect(response).to have_http_status(:success)
    end
  end

end
