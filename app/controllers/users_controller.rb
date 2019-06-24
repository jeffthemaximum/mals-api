class UsersController < ApplicationController
  skip_before_action :verify_authorized, :only => [:create]

  def create
    user = User.new(user_params)

    unless(user.save)
      return render json: {errors: user.errors}, status: 422
    end

    render json: user, serializer: UserSerializer, status: :ok
  end

  def update
    unless(@current_user.update(user_params))
      return render json: {errors: @current_user.errors}, status: 422
    end

    jwt = @current_user.create_jwt
    render json: @current_user, serializer: UserSerializer, status: :ok
  end

  private

    def user_params
      params.permit(:name)
    end
end
