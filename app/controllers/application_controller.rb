class ApplicationController < ActionController::API
  skip_before_action :verify_authenticity_token, raise: false

  include Authenticable
  include ErrorHandler

  rescue_from StandardError, with: :error_handler

  def index
    render json: { message: "Welcome to the Jotter API" }, status: :ok
  end
end
