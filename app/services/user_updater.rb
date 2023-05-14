class UserUpdater < ApplicationService
  def initialize(user, user_params = {})
    @user = user
    @email = user_params[:email] || @user.email
    @role = user_params[:role] || @user.role
  end

  def call
    update_user
  end

  private

    def update_user
      @user.update!(email: @email, role: @role)
    end
end
