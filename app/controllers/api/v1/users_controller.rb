module Api
  module V1
    class UsersController < ApiController
      skip_before_action :verify_authorized, :only => [:create]

      def create
        user = User.new(create_user_params)

        unless params[:unique_id].nil?
          device = Device.find_by(unique_id: params[:unique_id])
          user.devices << device
        end

        unless(user.save)
          return render json: {errors: user.errors}, status: 422
        end

        render json: user, serializer: UserSerializer, status: :ok
      end

      def hide
        @current_user.hide!(params[:id])
        head :ok
      end

      def show
        render json: @current_user, serializer: UserSerializer, status: :ok
      end

      def update
        if update_user_params[:avatar_file] || update_user_params[:avatar_url]
          if update_user_params[:avatar_file]
            @current_user.avatar_file = update_user_params[:avatar_file]
          end

          if update_user_params[:avatar_url]
            @current_user.avatar_url = update_user_params[:avatar_url]
          end

          if update_user_params[:name]
            @current_user.name = update_user_params[:name]
          end

          @current_user.save!
          return render json: @current_user, serializer: UserSerializer, status: :ok
        end

        if update_user_params[:avatar]
          name = Faker::Name.unique.first_name
          @current_user.update_avatar(name)
          return render json: @current_user, serializer: UserSerializer, status: :ok
        end

        unless @current_user.update(update_user_params)
          return render json: {errors: @current_user.errors}, status: 422
        end

        jwt = @current_user.create_jwt
        render json: @current_user, serializer: UserSerializer, status: :ok
      end

      private

        def create_user_params
          if !params[:latitude] || !params[:longitude]
            location = IpLocationService.call(request.remote_ip)
            params[:latitude] = location.location.latitude
            params[:longitude] = location.location.longitude
          end
          return params.permit(:name, :latitude, :longitude)
        end

        def update_user_params
          params.permit(:avatar, :avatar_file, :avatar_url, :latitude, :longitude, :name)
        end
    end
  end
end
