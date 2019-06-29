module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

  private
    def find_verified_user
      begin
        token = request.headers[:HTTP_SEC_WEBSOCKET_PROTOCOL].split(' ').last
        decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, {algorithm: "HS256"})[0]["data"]
        if (current_user = User.find(decoded_token["user_id"]))
          current_user
        else
          reject_unauthorized_connection
        end
      rescue
        reject_unauthorized_connection
      end
    end

 end
end
