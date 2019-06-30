class ApplicationController < ActionController::Base
  include AuthUtil

  before_action :authorize_request
  before_action :verify_authorized
end
