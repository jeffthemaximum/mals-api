module AuthUtil
  attr_accessor :current_user

  def authorized
    @is_authorized
  end

  def verify_authorized
    head(401) unless authorized?
  end

  private

    attr_accessor :is_authorized

    def authorized?
      @is_authorized
    end

    def authorize_request
      begin
        token = get_bearer_token
        if (token.present?)
          @current_user = User.find(decode_token(token)["user_id"])
          @is_authorized = @current_user.present?
        else
          @is_authorized = false
        end
      rescue => exception
        @is_authorized = false
      end
    end

    def get_bearer_token
      auth_header = request.headers["Authorization"]
      if (auth_header.present?)
        auth_header.split(" ").last
      else
        nil
      end
    end

    def decode_token(token)
      JWT.decode(token, Rails.application.credentials.secret_key_base, true, {algorithm: "HS256"})[0]["data"]
    end

    module Jwt
      def create_jwt
        expires_in = (Time.now + 10.years).to_i * 3600
        payload = { data: { user_id: self.id, exp: expires_in } }
        JWT.encode(payload, Rails.application.credentials.secret_key_base, "HS256")
      end
    end
end
