class ApiController < ActionController::API
  include AuthUtil
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  before_action :authorize_request
  before_action :verify_authorized

  def render_404
    errors = ['Not found']
    return render json: {errors: errors}, status: 404
  end
end
