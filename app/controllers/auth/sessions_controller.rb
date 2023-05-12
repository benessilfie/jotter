class Auth::SessionsController < ApplicationController
  def login
    user = User.find_by(email: user_params[:email])

    if user&.authenticate(user_params[:password])
      render json: { token: user.token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def logout
    current_user.update(auth_token: nil)
    head :no_content
  end

  private

    def user_params
      params.permit(:email, :password)
    end
end
