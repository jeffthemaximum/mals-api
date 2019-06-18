class UsersController < ApplicationController
  def get_or_create
    jwt = get_bearer_token

    unless (current_user)
      user = User.new(create_params)

      if (user.save)
        current_user = user
        jwt = user.create_jwt
      else
        return render json: {errors: user.errors}, status: 422
      end
    end

    render json: current_user, serializer: UserSerializer, jwt: jwt, status: :ok
  end

  private

    def create_params
      params.permit(:name)
    end
end
