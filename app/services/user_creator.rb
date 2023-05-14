class UserCreator < ApplicationService
  def initialize(user_params = {})
    @email = user_params[:email]
    @password = user_params[:password]
    @role = user_params[:role]
  end

  def call
    create_user
  end

  private

    def create_user
      User.create!(email: @email, password: @password, role: @role)
    end
end
