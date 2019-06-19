class UsersController < ApplicationController
  def create
    user = User.new(create_params)

    if (user.save)
      jwt = user.create_jwt
    else
      return render json: {errors: user.errors}, status: 422
    end

    render json: user, serializer: UserSerializer, jwt: jwt, status: :ok
  end

  private

    def create_params
      params.permit(:name)
    end
end
