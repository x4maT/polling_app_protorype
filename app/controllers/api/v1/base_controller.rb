class Api::V1::BaseController < ApplicationController
	include Response
  include ExceptionHandler
  before_action :authenticate_request
    
  attr_reader :current_user

  rescue_from Stripe::StripeError, with: :stripe_error
  rescue_from StandardError, with: :general_error

  def apn
    @apn ||= Houston::Client.development
    @apn.certificate ||= cert_file
    @apn.passphrase ||= ENV['PUSH_PASS']
    @apn
   end
 
  def cert_file
    File.read(".ebextensions/apns-dev.pem")
  end 

  def remote_ip
    if request.remote_ip == '127.0.0.1'
      '123.45.67.89'
    else
      request.remote_ip
    end
  end
  
  private

  def stripe_error(error)
    render json: { error: error.message }, status: :bad_request
  end

  def general_error(error)
    logger.error "Survey is not valid: #{error.message}"
    render json: { error: error.message }, status: :bad_request
  end
    
  def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end