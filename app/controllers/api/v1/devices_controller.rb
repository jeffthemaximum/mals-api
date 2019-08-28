module Api
  module V1
    class DevicesController < ApiController
      skip_before_action :verify_authorized, :only => [:get_or_create]

      def get_or_create
        unique_id = get_or_create_params[:unique_id]

        if unique_id.nil?
          unique_id = "server-#{SecureRandom.uuid}"
        end

        device = Device.find_by(unique_id: unique_id)
        if device.nil?
          device = Device.create(get_or_create_params)
        end
        render json: device, serializer: DeviceSerializer, status: :ok
      end

      private
        def get_or_create_params
          params.permit(
            :brand,
            :build_id,
            :build_number,
            :bundle_id,
            :carrier,
            :device,
            :device_country,
            :device_id,
            :device_name,
            :fingerprint,
            :first_install_time,
            :install_referrer,
            :manufacturer,
            :phone_number,
            :readable_version,
            :serial_number,
            :system_version,
            :timezone,
            :unique_id
          )
        end
    end
  end
end
