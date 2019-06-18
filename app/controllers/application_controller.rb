class ApplicationController < ActionController::API
  include AuthUtil

  before_action :authorize_request
end
