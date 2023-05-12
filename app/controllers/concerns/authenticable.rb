module Authenticable
  def current_user
    return @current_user if @current_user

    token = request.headers["Authorization"]&.split&.last
    raise JWT::DecodeError, "Missing token, please sign in or sign up" unless token

    decoded = JsonWebToken.decode(token)

    @current_user ||= User.find(decoded[:user_id])
    return @current_user if @current_user&.auth_token == token
  end

  def user_signed_in?
    render json: { error: "You need to sign in or sign up before continuing" }, status: :unauthorized unless current_user
  end
end
