class SendTextService < ApplicationService
  require 'twilio-ruby'

  def initialize(message, to)
    @from = Rails.application.credentials.twilio_phone_number
    @message = message
    @to = to
    @client = Twilio::REST::Client.new(Rails.application.credentials.twilio_api_key, Rails.application.credentials.twilio_auth_token)
  end

  def call
    if Rails.env.production?
      @client.messages.create(
        from: @from,
        to: @to,
        body: @message
      )
      Rails.logger.info "Production sent twilio text from: #{@from}; to: #{@to}; message: #{@message}"
    else
      Rails.logger.info "non-production, would have sent twilio text from: #{@from}; to: #{@to}; message: #{@message}"
    end
  end
end
