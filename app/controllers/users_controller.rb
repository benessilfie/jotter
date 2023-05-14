class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def show
    options = { include: %i[notes] }
    render json: UserSerializer.new(@user, options).serializable_hash, status: :ok
  end

  def create
    @user = UserCreator.call(user_params)
    render json: UserSerializer.new(@user).serializable_hash, status: :created
  end

  def update
    UserUpdater.call(@user, user_params)
    render json: UserSerializer.new(@user).serializable_hash, status: :ok
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

    def user_params
      return params.permit(:email, :role) if action_name == "update"
      params.permit(:email, :password, :role)
    end

    def set_user
      @user = current_user&.admin? ? User.find(params[:id]) : current_user

      if @user.nil?
        render json: { errors: ["You need to sign in or sign up before continuing"] }, status: :unauthorized
      elsif @user.id != params[:id].to_i && !@user.admin?
        render json: { errors: ["You are not authorized to perform this action"] }, status: :unauthorized
      end
    end
end
